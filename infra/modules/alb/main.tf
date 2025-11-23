resource "aws_security_group" "alb" {
  name        = "${var.project_name_prefix}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name_prefix}-alb-sg"
    }
  )
}

resource "aws_lb" "this" {
  name               = "${var.project_name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name_prefix}-alb"
    }
  )
}

resource "aws_lb_target_group" "blue" {
  name     = "${var.project_name_prefix}-tg-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "instance"

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name_prefix}-tg-blue"
      Role = "blue"
    }
  )
}

resource "aws_lb_target_group" "green" {
  name     = "${var.project_name_prefix}-tg-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "instance"

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name_prefix}-tg-green"
      Role = "green"
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name_prefix}-listener-http"
    }
  )
}



