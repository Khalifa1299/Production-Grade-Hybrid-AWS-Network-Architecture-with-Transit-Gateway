variable "cidr_block" {
  description = "CIDR block for the Network Firewall VPC"
  type        = string
  default     = "172.16.0.0/24"
}

variable "availability_zones" {
  description = "Availability Zones for firewall subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "transit_gateway_id" {
  description = "ID of the shared/central Transit Gateway"
  type        = string
}

variable "suricata_rules" {
  description = "Suricata-compatible rules string for the baseline stateful rule group"
  type        = string
  default     = "# TODO: add Suricata-compatible rules here"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
