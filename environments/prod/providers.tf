provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Network-Infrastructure"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "m3lcy"
    }
  }
}