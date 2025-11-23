terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "tfstate-blue-green-deploy-803767876973-us-east-2"
    key            = "blue-green-deploy/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tfstate-lock-blue-green-deploy"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

module "shared" {
  source = "./modules/shared"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                 = var.azs

  project_name_prefix = var.project_name_prefix
  default_tags        = var.default_tags
}

module "alb" {
  source = "./modules/alb"

  vpc_id            = module.shared.vpc_id
  public_subnet_ids = module.shared.public_subnet_ids

  project_name_prefix = var.project_name_prefix
  default_tags        = var.default_tags
}

module "blue" {
  source = "./modules/blue"

  vpc_id              = module.shared.vpc_id
  public_subnet_ids   = module.shared.public_subnet_ids
  instance_type       = var.instance_type
  key_pair_name       = var.key_pair_name
  project_name_prefix = var.project_name_prefix
  default_tags        = var.default_tags
  environment_name    = "blue"

  # ALB SG allows the EC2 SG to restrict inbound 80
  alb_security_group_id = module.alb.alb_security_group_id

  # Later we'll tighten this to your IP
  allowed_ssh_cidr = "0.0.0.0/0"

  # Placeholder for now; we'll fill this in when we design the user_data script
  user_data = file("${path.module}/user_data.sh")
}


module "green" {
  source = "./modules/green"

  vpc_id              = module.shared.vpc_id
  public_subnet_ids   = module.shared.public_subnet_ids
  instance_type       = var.instance_type
  key_pair_name       = var.key_pair_name
  project_name_prefix = var.project_name_prefix
  default_tags        = var.default_tags
  environment_name    = "green"

  alb_security_group_id = module.alb.alb_security_group_id
  allowed_ssh_cidr      = "0.0.0.0/0"

  user_data = file("${path.module}/user_data.sh")
}

# Attach BLUE EC2 instance to BLUE target group
resource "aws_lb_target_group_attachment" "blue_instance" {
  target_group_arn = module.alb.blue_target_group_arn
  target_id        = module.blue.instance_id
  port             = 80
}

# Attach GREEN EC2 instance to GREEN target group
resource "aws_lb_target_group_attachment" "green_instance" {
  target_group_arn = module.alb.green_target_group_arn
  target_id        = module.green.instance_id
  port             = 80
}
