output "vpc_id" {
  value = aws_vpc.this.id
}

output "tgw_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.this.id
}
