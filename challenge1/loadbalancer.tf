# Data

data "aws_elb_service_account" "root" {}

# Resources

resource "aws_lb" "web_alb" {
  name                       = "${local.name_prefix}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "web_alb" {
  name     = "${local.name_prefix}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "web_alb" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_alb.arn
  }

}

resource "aws_lb_target_group_attachment" "web_alb" {
  count            = var.web_instance_count[terraform.workspace]
  target_group_arn = aws_lb_target_group.web_alb.arn
  target_id        = aws_instance.web_instance[count.index].id
  port             = 80
}
