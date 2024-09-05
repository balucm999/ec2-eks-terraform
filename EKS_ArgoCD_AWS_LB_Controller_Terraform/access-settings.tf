#everything in this file is all about attaching amazoneksclusteradminpolicy in access settings in eks cluster
resource "aws_iam_user_policy_attachment" "balu_eks_admin" {
  user       = "balu"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
#imp note:amazoneksclusteradminpolicy didnt appear in IAM policy list,which was appeared in eks access settings,
#so if we give this amazoneksclusterpolicy then internally it will select amazoneksclusteradminpolicy in access settings

data "aws_eks_cluster" "eks_cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks_token" {
  name = data.aws_eks_cluster.eks_cluster.name
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_token.token
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    token                  = data.aws_eks_cluster_auth.eks_token.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  }
}
