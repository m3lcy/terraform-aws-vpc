output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "subnet_ids" {
  description = "All subnet IDs created in the VPC"
  value       = [for s in aws_subnet.enterprise_subnets : s.id]
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [for s in aws_subnet.enterprise_subnets : s.id if s.map_public_ip_on_launch]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = [for s in aws_subnet.enterprise_subnets : s.id if !s.map_public_ip_on_launch]
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Private route table IDs (one per private subnet/key)"
  value       = { for k, rt in aws_route_table.private : k => rt.id }
}

output "security_group_ids" {
  description = "Security group IDs for the VPC"
  value = {
    management = aws_security_group.management.id
    compute    = aws_security_group.compute.id
    internal   = aws_security_group.enterprise_internal.id
    guest      = aws_security_group.guest.id
  }
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = var.enable_nat_gateway ? { for k, n in aws_nat_gateway.this : k => n.id } : {}
}

output "nat_eip_ids" {
  description = "Elastic IP IDs used for NAT Gateways"
  value       = var.enable_nat_gateway ? { for k, e in aws_eip.nat : k => e.id } : {}
}

output "subnet_ids_by_key" {
  description = "Map of subnet IDs keyed by subnet name"
  value       = { for k, s in aws_subnet.enterprise_subnets : k => s.id }
}

output "flow_log_bucket_arn" {
  description = "ARN of the S3 bucket receiving VPC flow logs"
  value       = var.enable_flow_logs ? aws_s3_bucket.flow_logs[0].arn : null
}

output "flow_log_id" {
  description = "ID of the VPC Flow Log"
  value       = var.enable_flow_logs ? aws_flow_log.this[0].id : null
}