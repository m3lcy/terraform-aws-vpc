output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for s in aws_subnet.private : s.id]
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = var.enable_nat_gateway ? [for n in aws_nat_gateway.nat : n.id] : []
}

output "nat_eip_ids" {
  description = "List of Elastic IP IDs for NAT Gateways"
  value       = var.enable_nat_gateway ? [for e in aws_eip.nat : e.id] : []
}

output "availability_zones" {
  description = "List of Availability Zones used"
  value       = local.azs
}