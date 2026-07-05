# Create the Paymentology application load balancer
resource "aws_lb" "paymentology_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = merge(var.tags, { Name = "${var.project_name}-alb" })
}

resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# HTTP listener on port 80 for CloudFront origin traffic
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.paymentology_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Create HTTPS listener if certificate available
resource "aws_lb_listener" "https" {
  count             = var.tls_certificate_arn != "" ? 1 : 0
  load_balancer_arn = aws_lb.paymentology_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn = var.tls_certificate_arn
  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}