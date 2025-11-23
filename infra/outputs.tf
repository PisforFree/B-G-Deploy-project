output "vpc_id" {
  description = "ID of the project VPC"
  value       = module.shared.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.shared.public_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "blue_target_group_arn" {
  description = "ARN of the blue target group"
  value       = module.alb.blue_target_group_arn
}

output "green_target_group_arn" {
  description = "ARN of the green target group"
  value       = module.alb.green_target_group_arn
}

output "alb_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = module.alb.listener_arn
}
