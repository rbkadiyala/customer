
	# Filter out local zones, which are not currently supported 
	# with managed node groups
	data "aws_availability_zones" "available" {
	  filter {
		name   = "opt-in-status"
		values = ["opt-in-not-required"]
	  }
	}
	
	module "vpc" {
	  source  = "terraform-aws-modules/vpc/aws"
	  version = "~> 5.0"

	  name = local.vpc_name

	  cidr = local.cidr
	  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

	  private_subnets = local.private_subnets
	  public_subnets  = local.public_subnets

	  enable_nat_gateway   = local.enable_nat_gateway
	  single_nat_gateway   = local.single_nat_gateway
	  enable_dns_hostnames = local.enable_dns_hostnames

	  public_subnet_tags = {
		"kubernetes.io/role/elb" = 1
	  }

	  private_subnet_tags = {
		"kubernetes.io/role/internal-elb" = 1
	  }
	}

	module "eks" {
	  source  = "terraform-aws-modules/eks/aws"
	  version = "~> 20.0"

	  cluster_name    = local.cluster_name
	  cluster_version = local.cluster_version

	  cluster_endpoint_public_access           = local.cluster_endpoint_public_access
	  enable_cluster_creator_admin_permissions = local.enable_cluster_creator_admin_permissions

	  cluster_addons = {
		aws-ebs-csi-driver = {
		  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
		}
	  }

	  vpc_id     = module.vpc.vpc_id
	  subnet_ids = module.vpc.private_subnets

	  eks_managed_node_group_defaults = {
		ami_type = local.ami_type  # Using the local reference of the ami_type
	  }

	  eks_managed_node_groups = {
		two = {
		  name = "node-group-2"

		  instance_types = [local.instance_type]

		  min_size     = local.min_size
		  max_size     = local.max_size
		  desired_size = local.desired_size
		}
	  }
	}

	# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
	data "aws_iam_policy" "ebs_csi_policy" {
	  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
	}

	module "irsa-ebs-csi" {
	  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
	  version = "5.39.0"

	  create_role                   = true
	  role_name                     = "AmazonEKSTFEBSCSIRole-${local.project_name}"
	  provider_url                  = module.eks.oidc_provider
	  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
	  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
	}

