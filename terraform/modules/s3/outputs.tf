output "bucket_id" {
  description = "S3 bucket name / ID."
  value       = aws_s3_bucket.frontend.id
}

output "bucket_arn" {
  description = "S3 bucket ARN."
  value       = aws_s3_bucket.frontend.arn
}

output "bucket_regional_domain_name" {
  description = "Regional domain name for the S3 bucket (used as CloudFront origin)."
  value       = aws_s3_bucket.frontend.bucket_regional_domain_name
}

output "oac_id" {
  description = "CloudFront Origin Access Control ID."
  value       = aws_cloudfront_origin_access_control.frontend.id
}
