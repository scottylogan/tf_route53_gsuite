terraform {
  required_version = ">= 1.9.0"

  # lock down provider versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.73.0"
    }
  }
}
