terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "stolets-tf-state"
    key    = "staging-stolets-tf"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = var.aws_region
}
