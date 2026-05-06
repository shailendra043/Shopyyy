output "zone_id" {
  description = "Route 53 hosted zone ID."
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "Route 53 name servers — delegate your domain registrar to these."
  value       = aws_route53_zone.main.name_servers
}

output "acm_certificate_arn_us_east_1" {
  description = "ARN of the ACM certificate in us-east-1 (for CloudFront)."
  value       = aws_acm_certificate_validation.main.certificate_arn
}

output "acm_certificate_arn" {
  description = "ARN of the regional ACM certificate (for ALB)."
  value       = aws_acm_certificate_validation.regional.certificate_arn
}
