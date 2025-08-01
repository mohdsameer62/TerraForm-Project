variable "ami_id" {
    description = "This is the we are taking the value of ami to launch in autoscling"
    type = string
}

variable "instance_type" {
    description = "This is the instance type for template"
    type = string
}
variable "key_name" {
    description = "This is the instance key_pair for template"
    type = string
}
variable "security_group_ids" {
    description = "This is the instance security group for template"
    type = list(string)
}

variable "subnet_ids" {
    description = "this is subnet for auto auto scaling the server"
    type = list(string)
}

variable "max_size" {
    description  = "this max capacity of instance run"
    type = number
    default = 4
}

variable "min_size" {
    description = "this is minimum capacity of instance to run"
    type = number
    default = 2
}

variable "desired_capacity" {
    description = "this is desried Capacity of of Instance to run"
    type = number
    default = 2
}
variable "vpc_zone_identifier" {
  type = list(string)
}

variable "target_group_arn" {
  description = "The target group ARN to attach to the Auto Scaling Group"
  type        = string
}