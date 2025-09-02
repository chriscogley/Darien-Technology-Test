module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.1.5"

  name       = var.eks_cluster_name
  kubernetes_version = var.eks_cluster_version

  vpc_id     = module.fng-dev-vpc.id
  subnet_ids = module.fng-dev-vpc.private_subnet

  enable_irsa = true

  endpoint_public_access       = true
  endpoint_private_access      = true
  endpoint_public_access_cidrs = var.eks_admin_cidrs

  access_entries = {
    me_admin = {
      principal_arn = var.eks_iam_principal
      policy_associations = {
        admin = {
          policy_arn  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }

  addons = {
    vpc-cni = {
      addon_version = "v1.20.0-eksbuild.1"
    }
    kube-proxy = {
      addon_version = "v1.33.0-eksbuild.2"
    }
    coredns = {
      addon_version = "v1.12.2-eksbuild.4"
    }
    aws-ebs-csi-driver = {
      addon_version = "v1.48.0-eksbuild.1"
    }
  }

  eks_managed_node_groups = {
    fng-dev = {
      # ami_type       = "AL2023_ARM_64_STANDARD"
      # instance_types = ["t4g.large"]
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3a.large"]
      capacity_type  = "SPOT"

      min_size     = 1
      desired_size = 2
      max_size     = 2

      subnet_ids = module.fng-dev-vpc.private_subnet

      iam_role_additional_policies = {
        ecr_ro = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }

      labels = {
        role = "KubernetesNode"
        arch = "arm64"
      }

      tags = {
        Name = "${var.eks_cluster_name}-node"
      }
    }
  }
}