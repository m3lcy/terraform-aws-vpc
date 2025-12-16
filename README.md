# Terraform AWS Virtual Private Cloud Module (VPC)

A reusable Terraform module for deploying a high-availability AWS VPC with public and private subnets across multiple Availability Zones.

## Features

- Dynamic AZ selection
- Automatic CIDR carving for public/private IPv4 subnets
- Internet Gateway (IGW)
- Route tables for subnets
- HA NAT Gateways (one per AZ, optional)
- Dedicated Elastic IPs for NAT
- Full tagging support (`common_tags` + resource-specific)
- Cost control with `enable_nat_gateway` <br/>

Ideal for EKS, ECS, RDS or any application needing isolated public/private tiers. <br/>

## Usage

VPC:
```hcl
module "vpc" {
  source = "../src"

  vpc_cidr    = "10.0.0.0/16"
  name_prefix = "tfexample_dev"

  common_tags = {
    Environment = "dev"
    Project     = "terraform-aws-vpc_development"
    ManagedBy   = "terraform"
  }
}
```