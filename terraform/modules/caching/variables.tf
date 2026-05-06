variable "project_name" {
  description = "Short project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets for ElastiCache."
  type        = list(string)
}

variable "elasticache_security_group_id" {
  description = "Security group ID for ElastiCache."
  type        = string
}

variable "redis_node_type" {
  description = "ElastiCache node type."
  type        = string
  default     = "cache.t3.micro"
}
