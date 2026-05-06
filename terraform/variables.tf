# ---------------------------------------------------------------------------
# Global variables used across all modules
# ---------------------------------------------------------------------------

variable "aws_region" {
  description = "Primary AWS region where resources are deployed."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name (e.g. production, staging, dev)."
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Short project name used in resource names and tags."
  type        = string
  default     = "shopyyy"
}

# ---------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the two public subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the two private subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  description = "Two availability zones to spread resources across."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# ---------------------------------------------------------------------------
# DNS
# ---------------------------------------------------------------------------

variable "domain_name" {
  description = "Root domain name managed in Route 53 (e.g. shopyyy.com)."
  type        = string
  default     = "shopyyy.com"
}

# ---------------------------------------------------------------------------
# Compute — ECS / Fargate
# ---------------------------------------------------------------------------

variable "backend_container_image" {
  description = "Container image used for the backend API (ECR URI or Docker Hub)."
  type        = string
  default     = "public.ecr.aws/nginx/nginx:latest"
}

variable "backend_container_port" {
  description = "Port the backend container listens on."
  type        = number
  default     = 3000
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS Fargate task (256, 512, 1024, …)."
  type        = number
  default     = 512
}

variable "ecs_task_memory" {
  description = "Memory (MiB) for the ECS Fargate task."
  type        = number
  default     = 1024
}

variable "ecs_desired_count" {
  description = "Desired number of running ECS tasks."
  type        = number
  default     = 2
}

# ---------------------------------------------------------------------------
# Database — RDS PostgreSQL
# ---------------------------------------------------------------------------

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
  description = "Master username for RDS (stored in Secrets Manager)."
  type        = string
  default     = "shopyyy_admin"
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Allocated storage in GiB for the RDS instance."
  type        = number
  default     = 20
}

# ---------------------------------------------------------------------------
# Caching — ElastiCache Redis
# ---------------------------------------------------------------------------

variable "redis_node_type" {
  description = "ElastiCache node type for Redis."
  type        = string
  default     = "cache.t3.micro"
}

# ---------------------------------------------------------------------------
# Kafka — Amazon MSK
# ---------------------------------------------------------------------------

variable "msk_instance_type" {
  description = "MSK broker instance type."
  type        = string
  default     = "kafka.t3.small"
}

variable "msk_kafka_version" {
  description = "Apache Kafka version for the MSK cluster."
  type        = string
  default     = "3.5.1"
}

variable "msk_broker_volume_size" {
  description = "Storage volume size in GiB per MSK broker."
  type        = number
  default     = 20
}
