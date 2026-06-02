terraform {

 cloud {

   organization="YOUR_ORG"

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