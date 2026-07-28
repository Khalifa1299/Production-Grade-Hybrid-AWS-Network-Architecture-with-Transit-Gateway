# Site-to-Site VPN module
# Provisions a Customer Gateway and a VPN connection attached directly to the
# Transit Gateway, used as the backup/failover path to the corporate data center.

resource "aws_customer_gateway" "onprem" {
  bgp_asn    = var.onprem_bgp_asn
  ip_address = var.onprem_public_ip
  type       = "ipsec.1"

  tags = merge(var.tags, { Name = "onprem-customer-gateway" })
}

resource "aws_vpn_connection" "this" {
  customer_gateway_id = aws_customer_gateway.onprem.id
  transit_gateway_id  = var.transit_gateway_id
  type                = "ipsec.1"
  static_routes_only  = var.static_routes_only

  tags = merge(var.tags, { Name = "onprem-vpn-connection" })
}

resource "aws_ec2_transit_gateway_route_table_association" "vpn" {
  transit_gateway_attachment_id  = aws_vpn_connection.this.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "vpn" {
  transit_gateway_attachment_id  = aws_vpn_connection.this.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.route_table_id
}
