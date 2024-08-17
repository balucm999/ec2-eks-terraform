terraform {
  backend "s3" {
    bucket = "ec2-eks-jenkins-server"
    key    = "ec2-jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}