variable "region" {
  description = "AWS Region to deploy the spoke account resources into (must match Account A's Region)"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI named profile for Account B (spoke/workload account)"
  type        = string
  default     = "account-b"
}

variable "tgw_id" {
  description = "ID of the Transit Gateway shared from Account A via AWS RAM"
  type        = string
}

variable "production_route_table_id" {
  description = "ID of the Production Transit Gateway route table (from Account A outputs)"
  type        = string
}

variable "non_production_route_table_id" {
  description = "ID of the Non-Production Transit Gateway route table (from Account A outputs)"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources in Account B"
  type        = map(string)
  default = {
    Project     = "hybrid-cloud-connectivity"
    Environment = "spoke-workloads"
  }
}
