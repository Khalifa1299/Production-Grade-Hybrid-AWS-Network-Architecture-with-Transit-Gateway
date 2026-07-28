output "transit_gateway_id" {
  value = module.transit_gateway.transit_gateway_id
}

output "production_route_table_id" {
  value = module.transit_gateway.production_route_table_id
}

output "non_production_route_table_id" {
  value = module.transit_gateway.non_production_route_table_id
}

output "resource_share_arn" {
  value = aws_ram_resource_share.tgw_share.arn
}
