// infra/modules/green/main.tf

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "green_ec2" {
  name        = "${var.project_name_prefix}-${var.environment_name}-ec2-sg"
  description = "Security group for green EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags,
    {
      Name        = "${var.project_name_prefix}-${var.environment_name}-ec2-sg"
      Environment = var.environment_name
    }
  )
}

resource "aws_instance" "green" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[1] # <-- 2nd subnet
  vpc_security_group_ids = [aws_security_group.green_ec2.id]
  key_name               = var.key_pair_name

  user_data = var.user_data

  tags = merge(
    var.default_tags,
    {
      Name        = "ec2-${var.environment_name}-${var.project_name_prefix}"
      Environment = var.environment_name
    }
  )
}
