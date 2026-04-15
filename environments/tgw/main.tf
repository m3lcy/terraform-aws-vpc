data "terraform_remote_state" "prod" {
  backend = "s3"
  config = {
    bucket = "m3lcy-terraform-state"
    key    = "cloud-enterprise-network/prod/terraform.tfstate"
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

module "tgw" {
  source = "../../modules/tgw"

  name_prefix = var.name_prefix
  environment = var.environment
  aws_asn     = var.aws_asn

  vpc_attachments = {
    prod = {
      vpc_id     = data.terraform_remote_state.prod.outputs.vpc_id
      subnet_ids = data.terraform_remote_state.prod.outputs.mgmt_subnet_ids
    }
    shared-svc = {
      vpc_id     = data.terraform_remote_state.shared_svc.outputs.vpc_id
      subnet_ids = data.terraform_remote_state.shared_svc.outputs.mgmt_subnet_ids
    }
  }

  route_table_associations = {
    prod       = "prod"
    shared-svc = "shared-svc"
  }

  route_table_propagations = {
    prod       = ["prod", "shared-svc"]
    shared-svc = ["prod", "shared-svc"]
  }
}