module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  name_prefix = var.name_prefix

  subnet_config = var.subnet_config

  management_ssh_cidrs = var.management_ssh_cidrs

  enable_nat_gateway = false
}
