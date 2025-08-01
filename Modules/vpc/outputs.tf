
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "vpc_id" {
  description = "The ID of the newly created VPC."
  value       = aws_vpc.vpc_terraform.id # This points to the VPC defined inside the module
}

output "subnet_id" {
  description = "The ID of the newly  public subnet."
  value = aws_subnet.public[0].id
}

output "subnet_ids" {
  description = "List of public subnet IDs to be used in vpc_zone_identifier"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

