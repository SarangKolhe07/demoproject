output "alb_dns_name" {
  value = aws_lb.paymentology_alb.dns_name
}

output "alb_arn" {
  value = aws_lb.paymentology_alb.arn
}

output "alb_arn_suffix" {
  value = aws_lb.paymentology_alb.arn_suffix
}

output "alb_name" {
  value = aws_lb.paymentology_alb.name
}

output "target_group_arn" {
  value = aws_lb_target_group.web.arn
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.web.arn_suffix
}

