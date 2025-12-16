module "vpc" {
  source = "../../src"

  vpc_cidr    = "10.0.0.0/16"
  name_prefix = "tfexample_dev"

  common_tags = {
    Environment = "dev"
    Project     = "terraform-aws-vpc_development"
    ManagedBy   = "terraform"
  }

  enable_nat_gateway = true
}