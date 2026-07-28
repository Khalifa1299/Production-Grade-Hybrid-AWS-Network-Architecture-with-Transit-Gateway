terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Recommended: configure a remote backend (S3 + DynamoDB lock table) per environment.
  # backend "s3" {}
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}
