# Account B: Spoke / Workload Account
# Attaches Dev, Staging, and Prod VPCs to the Transit Gateway shared from Account A.
#
# Prerequisite: the AWS RAM resource share invitation from Account A must already be
# accepted in this account (see README.md, Step 2).

module "staging_vpc" {
  source = "../modules/vpc"

  name               = "staging-vpc"
  cidr_block         = "10.15.0.0/16"
  transit_gateway_id = var.tgw_id
  route_table_id     = var.non_production_route_table_id
  tags               = var.tags
}

module "prod_vpc" {
  source = "../modules/vpc"

  name               = "prod-vpc"
  cidr_block         = "10.16.0.0/16"
  transit_gateway_id = var.tgw_id
  route_table_id     = var.production_route_table_id
  tags               = var.tags
}

module "dev_vpc" {
  source = "../modules/vpc"

  name               = "dev-vpc"
  cidr_block         = "10.17.0.0/16"
  transit_gateway_id = var.tgw_id
  route_table_id     = var.non_production_route_table_id
  tags               = var.tags
}
