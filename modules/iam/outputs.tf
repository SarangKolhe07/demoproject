output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2.name
}
output "vpc_flow_logs_role_arn" {
  value = aws_iam_role.vpc_flow_logs.arn
}

