# aws_elb_service_account
data "aws_elb_service_account" "root" {}

# aws_lb
resource "aws_lb" "nginx_lb" {
  name               = "globo-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  access_logs {
    bucket  = module.s3_bucket.bucket.id
    prefix  = "alb-logs"
    enabled = true
  }

  tags = local.common_tags
}

resource "aws_lb_target_group" "nginx-tg" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  tags = local.common_tags
}


resource "aws_lb_listener" "nginx_lbl" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tg.arn
  }

  tags = local.common_tags
}

resource "aws_lb_target_group_attachment" "nginxs" {
  count            = var.instance_count[terraform.workspace]
  target_group_arn = aws_lb_target_group.nginx-tg.arn
  target_id        = aws_instance.nginxs[count.index].id
  port             = 80
}


