// infra/modules/blue/variables.tf

variable "vpc_id" {
  type        = string
  description = "VPC ID where the blue EC2 instance will live"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the blue instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for blue environment"
}

variable "key_pair_name" {
  type        = string
  description = "Name of the existing EC2 key pair to use for SSH"
}

variable "project_name_prefix" {
  type        = string
  description = "Project name prefix for tagging and naming"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to resources"
}

variable "environment_name" {
  type        = string
  description = "Environment name (e.g., blue)"
  default     = "blue"
}

variable "user_data" {
  type        = string
  description = "User data script to bootstrap Docker and the app"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group ID of the ALB, used to restrict HTTP ingress"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed to SSH to the instance"
  default     = "0.0.0.0/0" // you can tighten this later to your IP
}
