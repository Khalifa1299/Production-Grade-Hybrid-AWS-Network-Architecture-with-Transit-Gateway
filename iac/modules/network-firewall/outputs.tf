output "firewall_arn" {
  value = aws_networkfirewall_firewall.this.arn
}

output "vpc_id" {
  value = aws_vpc.firewall.id
}

output "tgw_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.firewall.id
}
