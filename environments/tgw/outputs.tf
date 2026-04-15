output "transit_gateway_id" {
  description = "TGW ID"
  value       = module.tgw.transit_gateway_id
}

output "vpc_attachment_ids" {
  description = "TGW attachment IDs"
  value       = module.tgw.vpc_attachment_ids
}

output "route_table_ids" {
  description = "TGW route table IDs"
  value       = module.tgw.route_table_ids
}