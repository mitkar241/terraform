terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.iam_cred_path
  profile                 = var.iam_cred_profile
  default_tags {
    tags = {
      Environment = "${var.tag_environment}"
      Name        = "${var.tag_name}"
      Owner       = "${var.tag_owner}"
    }
  }
}

/*
provider "aws" {
  region     = "ap-south-1"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}
*/
