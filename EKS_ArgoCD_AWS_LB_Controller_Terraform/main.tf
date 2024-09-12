#vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  map_public_ip_on_launch = true
  enable_dns_support      = true
  enable_dns_hostnames    = true
  enable_nat_gateway      = true
  single_nat_gateway      = true

  tags = {
    "kubernetes.io/cluster/k8s-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/k8s-cluster" = "shared"
    "kubernetes.io/role/elb"            = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/k8s-cluster" = "shared"
    "kubernetes.io/role/internal-elb"   = "1"
  }
}

#eks
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "k8s-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    # aws-load-balancer-controller = {
    #  enable_aws_load_balancer_controller = true
    #}note:its not applicable for cluster version 1.30
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets


  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_type = ["t3.medium"]
    }
  }
  node_security_group_additional_rules = {
    ingress_15017 = {
      description                   = "Cluster API - Istio Webhook namespace.sidecar-injector.istio.io"
      protocol                      = "TCP"
      from_port                     = 15017
      to_port                       = 15017
      type                          = "ingress"
      source_cluster_security_group = true
    }
    ingress_15012 = {
      description                   = "Cluster API to nodes ports/protocols"
      protocol                      = "TCP"
      from_port                     = 15012
      to_port                       = 15012
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
  enable_cluster_creator_admin_permissions = true


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

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


