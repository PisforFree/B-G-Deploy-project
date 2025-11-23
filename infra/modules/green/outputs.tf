output "instance_id" {
  description = "ID of the green EC2 instance"
  value       = aws_instance.green.id
}

output "instance_public_ip" {
  description = "Public IP of the green EC2 instance"
  value       = aws_instance.green.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the green EC2 instance"
  value       = aws_instance.green.private_ip
}

output "security_group_id" {
  description = "Security group ID for the green EC2 instance"
  value       = aws_security_group.green_ec2.id
}
