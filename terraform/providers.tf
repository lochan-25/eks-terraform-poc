terraform {

 cloud {

   organization="my-org-12345"

   workspaces {

      name="eks-cluster"

   }

 }

 required_providers {

   aws={

      source="hashicorp/aws"

   }

 }

}

provider "aws" {

 region="us-east-1"

}
