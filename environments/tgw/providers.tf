provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Cloud-Enterprise-Network"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "m3lcy"
    }
  }
}