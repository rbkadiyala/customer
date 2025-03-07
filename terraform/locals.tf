	# locals.tf

	locals {
	  # General Configuration
	  project_name  = "payroll"
	  environment   = "dev"
	  region        = "us-east-1"
	  app_name      = "customer"

	  # VPC and Cluster Names
	  vpc_name      = "${local.project_name}-vpc"
	  cluster_name  = "${local.project_name}-eks-cluster" 

	  # GitHub Repo and Other Resources
	  github_repo   = "github.com/${local.project_name}/repo"

	  # Subnets Configuration
	  cidr          = "10.0.0.0/16"
	  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
	  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

	  # EKS Cluster Settings
	  cluster_version                = "1.31"
	  cluster_endpoint_public_access = true
	  enable_cluster_creator_admin_permissions = true

	  # NAT Gateway Settings
	  enable_nat_gateway             = true
	  single_nat_gateway             = true
	  enable_dns_hostnames           = true

	  # Node Group Configuration
	  instance_type                  = "t3.small"
	  min_size                       = 1
	  max_size                       = 2
	  desired_size                   = 1

	  # AMI Type for EKS Node Group
	  ami_type                       = var.ami_type  # Referencing the variable

	  # Tags
	  tags = {
		Project      = local.project_name
		Environment  = local.environment
		Application  = local.app_name
		GithubRepo   = local.github_repo
	  }
	}