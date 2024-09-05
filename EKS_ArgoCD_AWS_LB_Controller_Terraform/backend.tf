terraform {
  backend "s3" {
    bucket = "eks-tf-state-file"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10.0"
    }
  }
}
