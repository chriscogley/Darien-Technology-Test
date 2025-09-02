provider "aws" {
  region                   = var.provider_region
  shared_config_files      = [var.provider_config_files]
  shared_credentials_files = [var.provider_creds]
  profile                  = var.provider_profile

  default_tags {
    tags = {
      Environment = var.tag_environment
      Project     = var.tag_project
      Owner       = var.tag_owner
      Developer   = var.tag_dev
    }
  }
}

terraform {
  backend "s3" {
    bucket       = "fng-dev-iaac"
    key          = "tfstates/fng-dev/terraform.tfstate"
    region       = "us-east-1"
    profile      = "fng-dev"
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.11.0"
    }
  }

  required_version = ">= 1.8.0"
}