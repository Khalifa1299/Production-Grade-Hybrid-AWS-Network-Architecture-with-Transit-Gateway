variable "name" {
  description = "Name of the VPC (e.g., dev-vpc, staging-vpc, prod-vpc)"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones to place TGW attachment subnets in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "transit_gateway_id" {
  description = "ID of the shared/central Transit Gateway to attach this VPC to"
  type        = string
}

variable "route_table_id" {
  description = "Transit Gateway route table ID to associate/propagate this attachment with"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
