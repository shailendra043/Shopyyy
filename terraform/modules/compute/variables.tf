variable "project_name" {
  description = "Short project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets where ECS tasks run."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks."
  type        = string
}

variable "alb_target_group_arn" {
  description = "ARN of the ALB target group."
  type        = string
}

variable "container_image" {
  description = "Container image for the backend API."
  type        = string
}

variable "container_port" {
  description = "Port the container listens on."
  type        = number
  default     = 3000
}

variable "task_cpu" {
  description = "CPU units for the Fargate task."
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Memory (MiB) for the Fargate task."
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Desired number of running ECS tasks."
  type        = number
  default     = 2
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret containing DB credentials."
  type        = string
}

variable "redis_endpoint" {
  description = "ElastiCache Redis primary endpoint address."
  type        = string
}

variable "msk_bootstrap_brokers" {
  description = "MSK bootstrap broker connection string."
  type        = string
}
