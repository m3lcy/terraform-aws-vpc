output "vpc_id" {
  description = "Shared services VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "subnet_ids_by_key" {
  description = "Subnet IDs keyed by subnet name"
  value       = module.vpc.subnet_ids_by_key
}

output "vpc_cidr" {
  description = "Prod VPC CIDR"
  value       = module.vpc.vpc_cidr
}

output "mgmt_subnet_ids" {
  description = "Prod mgmt subnet IDs for TGW attachment"
  value = [
    module.vpc.subnet_ids_by_key["mgmt-1a"],
    module.vpc.subnet_ids_by_key["mgmt-1b"],
    module.vpc.subnet_ids_by_key["mgmt-1c"],
  ]
}

output "ec2_instance_ids" {
  description = "Shared-svc EC2 instance IDs"
  value       = module.ec2_instance.instance_ids
}

output "ec2_instance_private_ips" {
  description = "Shared-svc EC2 private IPs"
  value       = module.ec2_instance.instance_private_ips
}