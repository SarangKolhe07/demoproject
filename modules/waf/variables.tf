variable "project_name" {
  description = "Project name prefix for WAF resources"
  type        = string
}

variable "alb_arn" {
  description = "ALB ARN used for any WAF ACL bindings or future protections"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "log_retention_in_days" {
  description = "Retention period (in days) for WAF CloudWatch log groups"
  type        = number
  default     = 30
}