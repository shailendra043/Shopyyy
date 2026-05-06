variable "project_name" {
  description = "Short project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "domain_name" {
  description = "Root domain name."
  type        = string
}

variable "s3_bucket_id" {
  description = "Name/ID of the S3 frontend bucket."
  type        = string
}

variable "s3_bucket_regional_domain" {
  description = "Regional domain name of the S3 bucket."
  type        = string
}

variable "s3_oac_id" {
  description = "CloudFront Origin Access Control ID for S3."
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate in us-east-1 for CloudFront."
  type        = string
}

variable "route53_zone_id" {
  description = "Route 53 hosted zone ID."
  type        = string
}
