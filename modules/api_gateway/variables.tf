variable "project_name" {
  description = "Project name prefix for API Gateway resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the REST API execution URL"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS name for API integration"
  type        = string
}

variable "stage_name" {
  description = "API Gateway deployment stage name"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "web_acl_arn" {
  description = "ARN of the regional WAFv2 Web ACL to associate with the API Gateway stage."
  type        = string
  default     = ""
}

variable "enable_waf" {
  description = "Whether to associate the WAFv2 Web ACL with the API Gateway stage."
  type        = bool
  default     = true
}