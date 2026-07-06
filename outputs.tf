output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = module.loadbalancer.alb_dns_name
}

output "api_gateway_url" {
  description = "Invokable URL for the API Gateway"
  value       = module.api_gateway.invoke_url
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.domain_name
}

output "cloudfront_url" {
  description = "Primary HTTPS URL (CloudFront distribution domain, no custom DNS required)"
  value       = "https://${module.cloudfront.domain_name}"
}

output "alb_https_url" {
  description = "Direct HTTPS URL to the ALB (TLS terminates on ALB port 443)"
  value       = var.acm_certificate_arn != "" ? "https://${module.loadbalancer.alb_dns_name}" : null
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "monitoring_log_group" {
  description = "CloudWatch log group name"
  value       = module.monitoring.log_group_name
}