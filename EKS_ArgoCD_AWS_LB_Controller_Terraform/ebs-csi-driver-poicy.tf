resource "aws_iam_role" "node_group_role" {
  name = "your-node-group-role-name"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}
# Output from the EKS module for node group role ARN
output "node_groups" {
  value = {
    "nodes" = {
      iam_role_name = aws_iam_role.node_group_role.name
      iam_role_arn  = aws_iam_role.node_group_role.arn
    }
  }
}


# Attach the policy to the node group role
resource "aws_iam_role_policy_attachment" "node_group_ebs_csi_policy" {
  role       = module.eks.eks_managed_node_groups["nodes"].iam_role_name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# EKS Managed Addon for AWS EBS CSI Driver
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = "v1.34.0-eksbuild.1" # Use the supported version

  depends_on = [module.eks]
}
