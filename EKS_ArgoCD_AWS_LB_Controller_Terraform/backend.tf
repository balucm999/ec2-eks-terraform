terraform {
  backend "s3" {
    bucket = "eks-tf-state-file"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    token                  = data.aws_eks_cluster_auth.eks_cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  }
}

