output "transit_gateway_id" {
  description = "TGW ID"
  value       = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_arn" {
  description = "TGW ARN"
  value       = aws_ec2_transit_gateway.this.arn
}

output "vpc_attachment_ids" {
  description = "TGW attachment IDs"
  value       = { for k, a in aws_ec2_transit_gateway_vpc_attachment.this : k => a.id }
}

output "route_table_ids" {
  description = "TGW route table IDs"
  value       = { for k, rt in aws_ec2_transit_gateway_route_table.this : k => rt.id }
}