variable "vpc_id" {
  description = "VPC where the ALB and target groups will live"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets for the internet-facing ALB"
  type        = list(string)
}

variable "project_name_prefix" {
  description = "Naming prefix for ALB and related resources"
  type        = string
}

variable "default_tags" {
  description = "Tags applied to ALB resources"
  type        = map(string)
}

variable "health_check_path" {
  description = "HTTP path used for ALB target group health checks"
  type        = string
  default     = "/healthz"
}

variable "listener_port" {
  description = "Port for the ALB listener"
  type        = number
  default     = 80
}
