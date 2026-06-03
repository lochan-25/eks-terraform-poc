data "aws_caller_identity" "current" {}

module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "eks-vpc"

  cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  enable_nat_gateway = true

  single_nat_gateway = true

  enable_dns_hostnames = true

  enable_dns_support = true

  map_public_ip_on_launch = true

  public_subnet_tags = {

    "kubernetes.io/role/elb" = "1"

    "kubernetes.io/cluster/demo-eks" = "shared"

  }

  private_subnet_tags = {

    "kubernetes.io/role/internal-elb" = "1"

    "kubernetes.io/cluster/demo-eks" = "shared"

  }

}



module "eks" {

  source  = "terraform-aws-modules/eks/aws"

  version = "~> 21.0"

  name = "demo-eks"

  kubernetes_version = "1.31"

  enable_cluster_creator_admin_permissions = true

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.public_subnets


  access_entries = {

    admin = {

      principal_arn = data.aws_caller_identity.current.arn

      policy_associations = {

        admin = {

          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

          access_scope = {

            type = "cluster"

          }

        }

      }

    }

  }


  eks_managed_node_groups = {

    default = {

      instance_types = ["t3.small"]

      min_size = 1

      max_size = 1

      desired_size = 1

      ami_type = "AL2023_x86_64_STANDARD"

      subnet_ids = module.vpc.public_subnets

    }

  }

}



output "cluster_name" {

  value = module.eks.cluster_name

}
