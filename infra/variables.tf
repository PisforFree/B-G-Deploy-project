variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-2"
}

variable "project_name_prefix" {
  description = "Prefix used for naming all project resources"
  type        = string
  default     = "blue-green-deploy"
}

variable "vpc_cidr" {
  description = "CIDR block for the blue-green VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "172.16.1.0/24", # us-east-2a
    "172.16.2.0/24", # us-east-2b
  ]
}

variable "azs" {
  description = "Availability Zones for the public subnets"
  type        = list(string)
  default = [
    "us-east-2a",
    "us-east-2b",
  ]
}

variable "instance_type" {
  description = "EC2 instance type for blue/green instances"
  type        = string
  default     = "t3.medium"
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name used for SSH"
  type        = string
  default     = "blue-green-deploy-key"
}

variable "default_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project = "blue-green-deploy"
    Owner   = "Alejandro"
  }
}

variable "user_data" {
  type        = string
  description = "User data script for EC2 instances"
  default     = "" # placeholder, will fill later
}

