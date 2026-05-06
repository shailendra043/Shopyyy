# ---------------------------------------------------------------------------
# Root outputs — surfaced after `terraform apply`
# ---------------------------------------------------------------------------

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name (e.g. d1234abcd.cloudfront.net)."
  value       = module.cloudfront.cloudfront_domain_name
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = module.load_balancer.alb_dns_name
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint (host:port)."
  value       = module.database.rds_endpoint
  sensitive   = true
}

output "redis_endpoint" {
  description = "ElastiCache Redis primary endpoint."
  value       = module.caching.redis_endpoint
  sensitive   = true
}

output "msk_bootstrap_brokers" {
  description = "MSK cluster bootstrap broker connection string."
  value       = module.kafka.bootstrap_brokers
  sensitive   = true
}

output "route53_name_servers" {
  description = "Name servers for the Route 53 hosted zone — delegate your domain here."
  value       = module.dns_ssl.name_servers
}
