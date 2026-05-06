# ---------------------------------------------------------------------------
# Root module — wires all child modules together
# ---------------------------------------------------------------------------

module "networking" {
  source = "./modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
}

module "dns_ssl" {
  source = "./modules/dns_ssl"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
}

module "load_balancer" {
  source = "./modules/load_balancer"

  project_name           = var.project_name
  environment            = var.environment
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  alb_security_group_id  = module.security_groups.alb_sg_id
  acm_certificate_arn    = module.dns_ssl.acm_certificate_arn
  backend_container_port = var.backend_container_port
}

module "cloudfront" {
  source = "./modules/cloudfront"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  project_name              = var.project_name
  environment               = var.environment
  domain_name               = var.domain_name
  s3_bucket_id              = module.s3.bucket_id
  s3_bucket_regional_domain = module.s3.bucket_regional_domain_name
  s3_oac_id                 = module.s3.oac_id
  alb_dns_name              = module.load_balancer.alb_dns_name
  acm_certificate_arn       = module.dns_ssl.acm_certificate_arn_us_east_1
  route53_zone_id           = module.dns_ssl.zone_id
}

# ── S3 bucket policy — allow CloudFront OAC to read (defined here to break the
#    circular dependency between the s3 and cloudfront modules)
data "aws_iam_policy_document" "frontend_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${module.s3.bucket_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront.distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = module.s3.bucket_id
  policy = data.aws_iam_policy_document.frontend_bucket_policy.json
}

module "compute" {
  source = "./modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  aws_region            = var.aws_region
  vpc_id                = module.networking.vpc_id
  private_subnet_ids    = module.networking.private_subnet_ids
  ecs_security_group_id = module.security_groups.ecs_sg_id
  alb_target_group_arn  = module.load_balancer.target_group_arn
  container_image       = var.backend_container_image
  container_port        = var.backend_container_port
  task_cpu              = var.ecs_task_cpu
  task_memory           = var.ecs_task_memory
  desired_count         = var.ecs_desired_count
  db_secret_arn         = module.database.db_secret_arn
  redis_endpoint        = module.caching.redis_endpoint
  msk_bootstrap_brokers = module.kafka.bootstrap_brokers
}

module "database" {
  source = "./modules/database"

  project_name          = var.project_name
  environment           = var.environment
  private_subnet_ids    = module.networking.private_subnet_ids
  rds_security_group_id = module.security_groups.rds_sg_id
  db_instance_class     = var.db_instance_class
  db_name               = var.db_name
  db_username           = var.db_username
  db_allocated_storage  = var.db_allocated_storage
}

module "caching" {
  source = "./modules/caching"

  project_name                  = var.project_name
  environment                   = var.environment
  private_subnet_ids            = module.networking.private_subnet_ids
  elasticache_security_group_id = module.security_groups.elasticache_sg_id
  redis_node_type               = var.redis_node_type
}

module "kafka" {
  source = "./modules/kafka"

  project_name          = var.project_name
  environment           = var.environment
  private_subnet_ids    = module.networking.private_subnet_ids
  msk_security_group_id = module.security_groups.msk_sg_id
  msk_instance_type     = var.msk_instance_type
  msk_kafka_version     = var.msk_kafka_version
  broker_volume_size    = var.msk_broker_volume_size
}
