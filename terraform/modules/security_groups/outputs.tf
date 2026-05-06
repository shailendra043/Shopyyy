output "alb_sg_id" {
  description = "ID of the ALB security group."
  value       = aws_security_group.alb.id
}

output "ecs_sg_id" {
  description = "ID of the ECS Fargate security group."
  value       = aws_security_group.ecs.id
}

output "rds_sg_id" {
  description = "ID of the RDS security group."
  value       = aws_security_group.rds.id
}

output "elasticache_sg_id" {
  description = "ID of the ElastiCache security group."
  value       = aws_security_group.elasticache.id
}

output "msk_sg_id" {
  description = "ID of the MSK security group."
  value       = aws_security_group.msk.id
}
