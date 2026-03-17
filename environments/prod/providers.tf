provider "aws" {
  region = var.aws_region

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  default_tags {
    tags = {
      Project     = "Cloud-Enterprise-Network"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "m3lcy"
    }
  }
}