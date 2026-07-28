output "vpn_connection_id" {
  value = aws_vpn_connection.this.id
}

output "tgw_attachment_id" {
  value = aws_vpn_connection.this.transit_gateway_attachment_id
}
