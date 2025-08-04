# Call modules here
module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"

  # Get the VPC ID from the VPC module's output
  vpc_id =  module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
}

module "autoscaling" {
  source = "./modules/autoscaling"

  ami_id = module.ec2.ami_id
  instance_type = module.ec2.instance_type
  key_name = module.ec2.key_name
  security_group_ids = module.ec2.security_group_ids
  vpc_zone_identifier = module.vpc.public_subnet_ids
  subnet_ids  = module.vpc.public_subnet_ids
  target_group_arn   = module.alb.target_group_arn
  
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnet_ids
}

