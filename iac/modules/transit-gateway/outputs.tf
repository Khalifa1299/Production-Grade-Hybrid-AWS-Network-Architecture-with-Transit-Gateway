output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "production_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.production.id
}

output "non_production_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.non_production.id
}

output "inspection_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.inspection.id
}
