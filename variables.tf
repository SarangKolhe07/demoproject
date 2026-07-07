variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Base name for the deployment"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "availability_zones" {
  description = "List of AZs to use"
  type        = list(string)
  default     = []
}

variable "az_count" {
  description = "Number of AZs to use"
  type        = number
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = []
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
variable "ingressport" {
  description = "Port for ingress rule from ALB to web tier"
  type        = number
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = ""
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
}

variable "alert_email" {
  description = "Email address to receive alerts (SNS subscription). A confirmation email will be sent.)"
  type        = string
  default     = ""
}
variable "acm_certificate_arn" {
  description = "ACM certificate ARN for the ALB HTTPS listener on port 443 (optional; leave empty to skip HTTPS listener)"
  type        = string
  default     = ""
}
