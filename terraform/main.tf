terraform {
  required_version = ">= 1.5"
  required_providers {
    aws        = { source = "hashicorp/aws",        version = "~> 5.0"  }
    kubernetes = { source = "hashicorp/kubernetes",  version = "~> 2.23" }
    helm       = { source = "hashicorp/helm",        version = "~> 2.11" }
  }
  backend "s3" {
    bucket         = "securebank-terraform-state"
    key            = "banking/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "securebank-tf-lock"
    encrypt        = true
  }
}
 
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = "SecureBank"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}
