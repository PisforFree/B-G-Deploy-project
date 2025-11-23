// infra/modules/blue/outputs.tf

output "instance_id" {
  description = "ID of the blue EC2 instance"
  value       = aws_instance.blue.id
}

output "instance_public_ip" {
  description = "Public IP of the blue EC2 instance"
  value       = aws_instance.blue.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the blue EC2 instance"
  value       = aws_instance.blue.private_ip
}

output "security_group_id" {
  description = "Security group ID for the blue EC2 instance"
  value       = aws_security_group.blue_ec2.id
}
