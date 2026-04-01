module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  name_prefix = var.name_prefix

  subnet_config        = var.subnet_config
  management_ssh_cidrs = var.management_ssh_cidrs
  enable_nat_gateway   = true

  enable_flow_logs      = var.enable_flow_logs
  flow_log_traffic_type = var.flow_log_traffic_type
}