# Transit Gateway module
# Provisions the central Transit Gateway hub and its default route tables.

resource "aws_ec2_transit_gateway" "this" {
  description                    = var.description
  amazon_side_asn                = var.amazon_side_asn
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_ec2_transit_gateway_route_table" "production" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = merge(var.tags, { Name = "${var.name}-prod-rt" })
}

resource "aws_ec2_transit_gateway_route_table" "non_production" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = merge(var.tags, { Name = "${var.name}-nonprod-rt" })
}

resource "aws_ec2_transit_gateway_route_table" "inspection" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = merge(var.tags, { Name = "${var.name}-inspection-rt" })
}
