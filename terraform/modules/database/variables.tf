variable "project_name" {
  description = "Short project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets for RDS."
  type        = list(string)
}

variable "rds_security_group_id" {
  description = "Security group ID for RDS."
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.medium"
}

variable "db_name" {
  description = "PostgreSQL database name."
  type        = string
  default     = "shopyyy"
}

variable "db_username" {
  description = "Master username for RDS."
  type        = string
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Allocated storage in GiB."
  type        = number
  default     = 20
}
