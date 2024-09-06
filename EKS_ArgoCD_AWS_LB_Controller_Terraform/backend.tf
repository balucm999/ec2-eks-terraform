terraform {
  backend "s3" {
    bucket = "eks-ec2"
    key    = "eks/terraform.tfstate"
    region = "us-west-1"
  }
}


