data "terraform_remote_state" "tgw" {
  backend = "s3"
  config = {
    bucket = "m3lcy-terraform-state"
    key    = "cloud-enterprise-network/tgw/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "shared_svc" {
  backend = "s3"
  config = {
    bucket = "m3lcy-terraform-state"
    key    = "cloud-enterprise-network/shared-svc/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  remote_tgw_routes = try(
    [
      {
        destination_cidr = data.terraform_remote_state.shared_svc.outputs.vpc_cidr
        tgw_id           = data.terraform_remote_state.tgw.outputs.transit_gateway_id
      }
    ],
    []
  )
}

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

  tgw_routes = length(var.tgw_routes) > 0 ? var.tgw_routes : local.remote_tgw_routes
}