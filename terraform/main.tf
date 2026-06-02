module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "eks-vpc"

  cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b"
  ]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]

  enable_nat_gateway = true

  single_nat_gateway = true

  enable_dns_hostnames = true

  enable_dns_support = true

}



module "eks" {

  source  = "terraform-aws-modules/eks/aws"

  version = "~> 21.0"

  name = "demo-eks"

  kubernetes_version = "1.31"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnets


  eks_managed_node_groups = {

    default = {

      instance_types = ["t3.small"]

      min_size = 1

      max_size = 1

      desired_size = 1

      ami_type = "AL2023_x86_64_STANDARD"

    }

  }

}



output "cluster_name" {

 value = module.eks.cluster_name

}
