# AWS Network Firewall module
# Provisions the Network Firewall VPC, firewall, and a baseline rule group used to
# inspect traffic routed through the Transit Gateway inspection route table.

resource "aws_vpc" "firewall" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "network-firewall-vpc" })
}

resource "aws_subnet" "firewall" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.firewall.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, { Name = "firewall-subnet-${count.index}" })
}

resource "aws_networkfirewall_rule_group" "baseline" {
  capacity = 100
  name     = "baseline-stateful-rule-group"
  type     = "STATEFUL"

  rule_group {
    rules_source {
      rules_string = var.suricata_rules
    }
  }

  tags = var.tags
}

resource "aws_networkfirewall_firewall_policy" "this" {
  name = "hub-firewall-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.baseline.arn
    }
  }

  tags = var.tags
}

resource "aws_networkfirewall_firewall" "this" {
  name                = "hub-network-firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn
  vpc_id              = aws_vpc.firewall.id

  dynamic "subnet_mapping" {
    for_each = aws_subnet.firewall
    content {
      subnet_id = subnet_mapping.value.id
    }
  }

  tags = var.tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "firewall" {
  transit_gateway_id                               = var.transit_gateway_id
  vpc_id                                            = aws_vpc.firewall.id
  subnet_ids                                        = aws_subnet.firewall[*].id
  transit_gateway_default_route_table_association   = false
  transit_gateway_default_route_table_propagation   = false

  tags = merge(var.tags, { Name = "network-firewall-attachment" })
}
