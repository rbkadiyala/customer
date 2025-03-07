# output.tf

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "The subnet IDs for the VPC"
  value       = module.vpc.private_subnets
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "instance_type" {
  description = "The instance type used in the node group"
  value       = var.instance_type
}

output "ami_type" {
  description = "The AMI type used in the node group"
  value       = var.ami_type
}

output "github_repo" {
  description = "The GitHub repository for the project"
  value       = var.github_repo
}
