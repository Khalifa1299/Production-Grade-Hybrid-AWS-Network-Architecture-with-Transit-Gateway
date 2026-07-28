variable "create_dx_gateway" {
  description = "Whether to create a new Direct Connect Gateway (false to use an existing one)"
  type        = bool
  default     = true
}

variable "dx_gateway_name" {
  description = "Name for the new Direct Connect Gateway (if created)"
  type        = string
  default     = "hub-dxgw"
}

variable "dx_gateway_asn" {
  description = "Amazon side ASN for the new Direct Connect Gateway (if created)"
  type        = number
  default     = 64513
}

variable "existing_dx_gateway_id" {
  description = "ID of an existing Direct Connect Gateway to associate (if create_dx_gateway is false)"
  type        = string
  default     = ""
}

variable "transit_gateway_id" {
  description = "ID of the shared/central Transit Gateway"
  type        = string
}

variable "allowed_prefixes" {
  description = "On-premises CIDR ranges allowed to be advertised over this Direct Connect Gateway association"
  type        = list(string)
  default     = []
}
