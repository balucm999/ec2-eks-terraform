terraform {
  backend "s3" {
    bucket = "eks-tf-state-file"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
