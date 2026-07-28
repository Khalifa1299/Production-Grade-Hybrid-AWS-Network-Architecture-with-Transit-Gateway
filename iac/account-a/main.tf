# Account A: Hub / Shared Networking Account
# Provisions the central Transit Gateway, spoke VPCs (Dev/Staging/Prod), the
# Network Firewall VPC, the Route 53 Resolver VPC, and hybrid connectivity
# (Direct Connect + Site-to-Site VPN backup).

module "transit_gateway" {
  source = "../modules/transit-gateway"

  name = "hub-tgw"
  tags = var.tags
}

module "prod_vpc" {
  source = "../modules/vpc"

  name               = "prod-vpc"
  cidr_block         = "10.0.0.0/16"
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  route_table_id     = module.transit_gateway.production_route_table_id
  tags               = var.tags
}

module "dev_vpc" {
  source = "../modules/vpc"

  name               = "dev-vpc"
  cidr_block         = "10.1.0.0/16"
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  route_table_id     = module.transit_gateway.non_production_route_table_id
  tags               = var.tags
}

module "staging_vpc" {
  source = "../modules/vpc"

  name               = "staging-vpc"
  cidr_block         = "10.2.0.0/16"
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  route_table_id     = module.transit_gateway.non_production_route_table_id
  tags               = var.tags
}

module "network_firewall" {
  source = "../modules/network-firewall"

  cidr_block         = "172.16.0.0/24"
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  tags               = var.tags
}

module "route53_resolver" {
  source = "../modules/route53-resolver"

  cidr_block         = "172.16.1.0/24"
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  onprem_domain      = var.onprem_domain
  onprem_dns_ips     = var.onprem_dns_ips
  tags               = var.tags
}

module "direct_connect" {
  source = "../modules/direct-connect"

  transit_gateway_id = module.transit_gateway.transit_gateway_id
  allowed_prefixes   = ["10.0.0.0/8"]
}

module "vpn_backup" {
  source = "../modules/vpn"

  transit_gateway_id = module.transit_gateway.transit_gateway_id
  onprem_public_ip   = var.onprem_public_ip
  onprem_bgp_asn     = var.onprem_bgp_asn
  route_table_id     = module.transit_gateway.production_route_table_id
  tags               = var.tags
}

# Share the Transit Gateway with spoke accounts via AWS RAM
resource "aws_ram_resource_share" "tgw_share" {
  name                      = "tgw-hub-share"
  allow_external_principals = false
  tags                      = var.tags
}

resource "aws_ram_resource_association" "tgw" {
  resource_arn       = "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:transit-gateway/${module.transit_gateway.transit_gateway_id}"
  resource_share_arn = aws_ram_resource_share.tgw_share.arn
}

resource "aws_ram_principal_association" "spoke_accounts" {
  for_each           = toset(var.spoke_account_ids)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.tgw_share.arn
}

data "aws_caller_identity" "current" {}
