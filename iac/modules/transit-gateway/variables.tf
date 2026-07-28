variable "name" {
  description = "Name tag for the Transit Gateway"
  type        = string
  default     = "hub-tgw"
}

variable "description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = "Central hub Transit Gateway for hybrid cloud connectivity"
}

variable "amazon_side_asn" {
  description = "Private ASN for the Amazon side of the Transit Gateway (used for Direct Connect / VPN BGP)"
  type        = number
  default     = 64512
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
