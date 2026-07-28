variable "cidr_block" {
  description = "CIDR block for the Resolver VPC"
  type        = string
  default     = "172.16.1.0/24"
}

variable "availability_zones" {
  description = "Availability Zones for resolver endpoint subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "transit_gateway_id" {
  description = "ID of the shared/central Transit Gateway"
  type        = string
}

variable "onprem_domain" {
  description = "On-premises DNS domain to forward queries for (e.g., corp.example.internal)"
  type        = string
  default     = "corp.example.internal."
}

variable "onprem_dns_ips" {
  description = "IP addresses of the on-premises DNS servers to forward queries to"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
