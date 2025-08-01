output "public_ip" {
    description = "This is the public ip of instance"
    value = aws_instance.server.public_ip
}

output "ami_id" {
    description = "This the ami id storing for template"
    value = aws_ami_from_instance.ami_server.id
}

output "instance_type" {
  description = "The instance type of the created EC2 server."
  value       = aws_instance.server.instance_type
}

output "key_name" {
  description = "The instance type of the created EC2 server."
  value       = aws_instance.server.key_name
}

output "security_group_ids" {
  description = "The instance security of the created EC2 server."
  value       = aws_instance.server.security_groups
}

