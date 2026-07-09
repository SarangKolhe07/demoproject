variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = []
}

variable "create_database_subnets" {
  description = "Whether to create database subnets"
  type        = bool
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}

variable "vpc_flow_logs_log_group_arn" {
  description = "CloudWatch log group ARN for VPC flow logs"
  type        = string
}

variable "vpc_flow_logs_iam_role_arn" {
  description = "IAM role ARN used by VPC flow logs to publish to CloudWatch"
  type        = string
}