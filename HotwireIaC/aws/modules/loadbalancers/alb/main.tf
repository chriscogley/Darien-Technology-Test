resource "aws_elb" "main" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = var.alb_type
  security_groups    = [var.alb_sg]
  subnets            = [var.alb_subnets]

  enable_deletion_protection = true
  desync_mitigation_mode = var.alb_desync_mitigation

  access_logs {
    bucket  = ""
    prefix  = ""
    enabled = true
  }

  tags = {
    Name = var.alb_name
  }
}