resource "aws_wafv2_web_acl" "cloudfront" {
  name        = "${var.project_name}-cloudfront-waf"
  description = "WAF ACL for CloudFront distribution"
  scope       = "CLOUDFRONT"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-cloudfront-waf-metric"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "managed-rule-set-metric"
      sampled_requests_enabled   = true
    }
  }

  tags = var.tags
}

resource "aws_wafv2_web_acl" "regional" {
  name        = "${var.project_name}-alb-waf"
  description = "WAF ACL for ALB"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-alb-waf-metric"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "managed-rule-set-metric"
      sampled_requests_enabled   = true
    }
  }

  tags = var.tags
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.regional.arn
}

# WAF log group names must begin with "aws-waf-logs-" for CloudWatch delivery to work.
resource "aws_cloudwatch_log_group" "cloudfront" {
  name              = "aws-waf-logs-${var.project_name}-cloudfront"
  retention_in_days = var.log_retention_in_days

  tags = merge(var.tags, { Name = "${var.project_name}-cloudfront-waf-logs" })
}

resource "aws_cloudwatch_log_group" "regional" {
  name              = "aws-waf-logs-${var.project_name}-alb"
  retention_in_days = var.log_retention_in_days

  tags = merge(var.tags, { Name = "${var.project_name}-alb-waf-logs" })
}

resource "aws_wafv2_web_acl_logging_configuration" "cloudfront" {
  log_destination_configs = [aws_cloudwatch_log_group.cloudfront.arn]
  resource_arn            = aws_wafv2_web_acl.cloudfront.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "regional" {
  log_destination_configs = [aws_cloudwatch_log_group.regional.arn]
  resource_arn            = aws_wafv2_web_acl.regional.arn
}