output "inbound_endpoint_id" {
  value = aws_route53_resolver_endpoint.inbound.id
}

output "outbound_endpoint_id" {
  value = aws_route53_resolver_endpoint.outbound.id
}

output "vpc_id" {
  value = aws_vpc.resolver.id
}
