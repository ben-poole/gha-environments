terraform {
  required_version = ">= 1.1.0"
}

terraform {
  required_providers {
    aws = {
      version = "~> 3.57.0"
    }
  }
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
  }
}

// Used to fetch account id
data "aws_caller_identity" "current" {}
