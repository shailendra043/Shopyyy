output "redis_endpoint" {
  description = "Redis primary endpoint address."
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
  sensitive   = true
}

output "redis_port" {
  description = "Redis port."
  value       = aws_elasticache_replication_group.main.port
}

output "redis_auth_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the Redis AUTH token."
  value       = aws_secretsmanager_secret.redis_auth.arn
}
