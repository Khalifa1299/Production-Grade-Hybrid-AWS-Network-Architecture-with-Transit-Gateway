# Direct Connect module
# Associates an existing Direct Connect Gateway with the Transit Gateway, providing
# the primary path to the corporate data center.
#
# NOTE: This module assumes the Direct Connect connection and Virtual Interface (VIF)
# have already been provisioned/ordered separately (physical cross-connect lead times
# apply), and that a Direct Connect Gateway already exists or is created here.

resource "aws_dx_gateway" "this" {
  count           = var.create_dx_gateway ? 1 : 0
  name            = var.dx_gateway_name
  amazon_side_asn = var.dx_gateway_asn
}

resource "aws_dx_gateway_association" "tgw" {
  dx_gateway_id         = var.create_dx_gateway ? aws_dx_gateway.this[0].id : var.existing_dx_gateway_id
  associated_gateway_id = var.transit_gateway_id

  allowed_prefixes = var.allowed_prefixes
}
