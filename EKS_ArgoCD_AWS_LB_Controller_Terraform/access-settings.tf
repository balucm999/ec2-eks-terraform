#everything in this file is all about attaching amazoneksclusteradminpolicy in access settings in eks cluster
resource "aws_iam_user_policy_attachment" "balu_eks_admin" {
  user       = "balu"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
#imp note:amazoneksclusteradminpolicy didnt appear in IAM policy list,which was appeared in eks access settings,
#so if we give this amazoneksclusterpolicy then internally it will select amazoneksclusteradminpolicy in access settings
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"  # Specify exact version here
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"  # Specify exact version here
    }
  }
}


