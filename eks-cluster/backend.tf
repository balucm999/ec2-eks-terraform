terraform {
  backend "s3" {
    bucket = "ec2-eks-jenkins-server"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"

  }
}