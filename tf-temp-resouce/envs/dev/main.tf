terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project     = "aws-dva-exe-2"
    Environment = "dev"
    ManagedBy   = "terraform"
    Author      = "Phu Phuoc"
  }
}

module "network" {
  source = "../../modules/network"
}

module "security_group" {
  source = "../../modules/security_group"
  vpc_id = module.network.vpc_id
}

module "compute" {
  source        = "../../modules/compute"
  web_sg_id     = module.security_group.web_sg_id
  instance_type = var.instance_type
  web_servers   = var.web_servers
  tags          = local.common_tags
}

module "alb" {
  source           = "../../modules/alb"
  alb_sg_id        = module.security_group.alb_sg_id
  vpc_id           = module.network.vpc_id
  subnet_ids       = module.network.subnet_ids
  ec2_instance_ids = module.compute.instance_ids
  tags             = local.common_tags
}

output "alb_dns" {
  value = module.alb.alb_dns
}
