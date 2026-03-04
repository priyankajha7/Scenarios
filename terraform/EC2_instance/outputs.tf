output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.ec2_instance.id
}

output "public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.ec2_instance.public_ip
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.ec2_sg.id
}