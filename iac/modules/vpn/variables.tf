variable "transit_gateway_id" {
  description = "ID of the shared/central Transit Gateway"
  type        = string
}

variable "onprem_public_ip" {
  description = "Public IP address of the on-premises Customer Gateway device"
  type        = string
}

variable "onprem_bgp_asn" {
  description = "BGP ASN of the on-premises Customer Gateway device"
  type        = number
  default     = 65000
}

variable "static_routes_only" {
  description = "Whether the VPN connection uses static routes instead of BGP"
  type        = bool
  default     = false
}

variable "route_table_id" {
  description = "Transit Gateway route table ID to associate/propagate this VPN attachment with"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
