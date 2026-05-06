variable "project_name" {
  description = "Short project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the two private subnets for MSK brokers."
  type        = list(string)
}

variable "msk_security_group_id" {
  description = "Security group ID for the MSK cluster."
  type        = string
}

variable "msk_instance_type" {
  description = "MSK broker instance type."
  type        = string
  default     = "kafka.t3.small"
}

variable "msk_kafka_version" {
  description = "Apache Kafka version."
  type        = string
  default     = "3.5.1"
}

variable "broker_volume_size" {
  description = "EBS storage volume size in GiB per broker."
  type        = number
  default     = 20
}
