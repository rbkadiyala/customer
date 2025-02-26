terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Use the latest version for AWS provider
    }
  }
  required_version = ">= 1.5.0"  # Use the latest stable Terraform version
}

provider "aws" {
  region = local.aws_region
}

locals {
  # Define all variables in the locals block
  aws_region           = "us-east-1"
  cluster_name         = "my-eks-cluster"
  ecr_repository_name  = "my-spring-boot-app"
  vpc_name             = "my-vpc"
  cidr_block           = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  instance_type        = "t2.small"
  node_desired_capacity = 1
  node_max_capacity    = 2
  node_min_capacity    = 1
  environment          = "dev"
  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  encryption_type      = "AES256"
  image_tag_mutability = "IMMUTABLE"
  prevent_destroy      = true

  # IAM Policies for the EKS Cluster
  eks_iam_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

resource "aws_ecr_repository" "this" {
  name                 = local.ecr_repository_name
  image_tag_mutability = local.image_tag_mutability
  encryption_configuration {
    encryption_type = local.encryption_type
  }

  lifecycle {
    prevent_destroy = local.prevent_destroy
  }

  tags = {
    Environment = local.environment
    Terraform   = "true"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"  # Ensure to use a version that aligns with your Terraform version

  name          = local.vpc_name
  cidr          = local.cidr_block
  azs           = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = local.enable_nat_gateway
  enable_vpn_gateway = local.enable_vpn_gateway

  tags = {
    Terraform   = "true"
    Environment = local.environment
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"  # Use latest version of the EKS module

  cluster_name = local.cluster_name
  subnets      = module.vpc.public_subnets
  vpc_id       = module.vpc.vpc_id

  tags = {
    Terraform   = "true"
    Environment = local.environment
  }

  node_groups = {
    default = {
      instance_type    = local.instance_type
      desired_capacity = local.node_desired_capacity
      max_capacity     = local.node_max_capacity
      min_capacity     = local.node_min_capacity

      additional_tags = {
        Terraform   = "true"
        Environment = local.environment
      }
    }
  }

  # Configure IAM role for the EKS Cluster (optional best practice)
  cluster_iam_role_additional_policies = local.eks_iam_policies
}

output "ecr_repository_url" {
  value = aws_ecr_repository.this.repository_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}
