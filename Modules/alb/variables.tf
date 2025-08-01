variable "vpc_id" {
  type        = string
  description = "Vpc id for security group for alb"
}

variable "subnet_ids" {
    description = "this is subnet for auto auto scaling the server"
    type = list(string)
}

variable alb_name {
    description = "This is the alb target group name"
    type = string
    default = "server-alb-target"
}

