variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones for public subnets"
  type        = list(string)
}

variable "project_name_prefix" {
  description = "Naming prefix for resources"
  type        = string
}

variable "default_tags" {
  description = "Tags applied to all shared resources"
  type        = map(string)
}
