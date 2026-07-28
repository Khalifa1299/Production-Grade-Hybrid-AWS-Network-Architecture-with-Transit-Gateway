variable "region" {
  description = "AWS Region to deploy the hub account resources into"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI named profile for Account A (hub/networking account)"
  type        = string
  default     = "account-a"
}

variable "spoke_account_ids" {
  description = "List of AWS account IDs to share the Transit Gateway with via AWS RAM"
  type        = list(string)
  default     = []
}

variable "onprem_public_ip" {
  description = "Public IP of the on-premises Customer Gateway device (for Site-to-Site VPN)"
  type        = string
}

variable "onprem_bgp_asn" {
  description = "BGP ASN of the on-premises Customer Gateway device"
  type        = number
  default     = 65000
}

variable "onprem_domain" {
  description = "On-premises DNS domain for split-horizon forwarding"
  type        = string
  default     = "corp.example.internal."
}

variable "onprem_dns_ips" {
  description = "On-premises DNS server IPs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags applied to all resources in Account A"
  type        = map(string)
  default = {
    Project     = "hybrid-cloud-connectivity"
    Environment = "shared-networking"
  }
}
