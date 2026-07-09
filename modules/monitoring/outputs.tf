output "log_group_name" {
  value = aws_cloudwatch_log_group.web.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "vpc_flow_logs_log_group_arn" {
  value = aws_cloudwatch_log_group.vpc_flow_logs.arn
}