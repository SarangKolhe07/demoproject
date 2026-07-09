variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = ""
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ASG placement"
  type        = list(string)
}

variable "web_security_group_id" {
  description = "Security group for EC2 instances"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN for register instances"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name for EC2 instances"
  type        = string
}

variable "environment" {
  description = "Deployment environment for instance user data"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
