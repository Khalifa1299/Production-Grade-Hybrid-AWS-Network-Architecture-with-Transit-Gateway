# Route 53 Resolver module (Split-Horizon DNS)
# Provisions inbound and outbound Resolver endpoints in a dedicated VPC attached to
# the Transit Gateway, plus forwarding rules for on-premises domains.

resource "aws_vpc" "resolver" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "resolver-vpc" })
}

resource "aws_subnet" "resolver" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.resolver.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, { Name = "resolver-subnet-${count.index}" })
}

resource "aws_security_group" "resolver" {
  name_prefix = "resolver-sg-"
  vpc_id      = aws_vpc.resolver.id

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_route53_resolver_endpoint" "inbound" {
  name      = "inbound-resolver"
  direction = "INBOUND"

  security_group_ids = [aws_security_group.resolver.id]

  dynamic "ip_address" {
    for_each = aws_subnet.resolver
    content {
      subnet_id = ip_address.value.id
    }
  }

  tags = var.tags
}

resource "aws_route53_resolver_endpoint" "outbound" {
  name      = "outbound-resolver"
  direction = "OUTBOUND"

  security_group_ids = [aws_security_group.resolver.id]

  dynamic "ip_address" {
    for_each = aws_subnet.resolver
    content {
      subnet_id = ip_address.value.id
    }
  }

  tags = var.tags
}

resource "aws_route53_resolver_rule" "onprem_forwarding" {
  domain_name          = var.onprem_domain
  name                 = "forward-to-onprem"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id

  dynamic "target_ip" {
    for_each = var.onprem_dns_ips
    content {
      ip = target_ip.value
    }
  }

  tags = var.tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "resolver" {
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                           = aws_vpc.resolver.id
  subnet_ids                                       = aws_subnet.resolver[*].id
  transit_gateway_default_route_table_association  = false
  transit_gateway_default_route_table_propagation  = false

  tags = merge(var.tags, { Name = "resolver-attachment" })
}
