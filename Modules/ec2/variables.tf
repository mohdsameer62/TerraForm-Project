variable "vpc_id" {
  description = "The ID of the VPC to deploy resources into."
  type        = string
}
variable "subnet_id" {
  description = "The ID of the subnet public launch the resources into"
  type = string
}

variable "aws_instance_type_" {
  description = "The the instance type is for launch the Ec2 instace"
  default = "t2.micro"
  type = string
}

variable "aws_ami_" {
  description = "The the instance ami is for launch the Ec2 instace"
  default = "ami-0f918f7e67a3323f0"
  type = string
}
