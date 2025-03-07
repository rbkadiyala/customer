# variables.tf

variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "demo"
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "payroll"
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for VPC"
  type        = bool
  default     = true
}

variable "cluster_version" {
  description = "Version of the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "cluster_endpoint_public_access" {
  description = "Whether the cluster endpoint is publicly accessible"
  type        = bool
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Enable cluster creator admin permissions"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "Instance type for EKS node groups"
  type        = string
  default     = "t3.small"
}

variable "min_size" {
  description = "Minimum size of the EKS node group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the EKS node group"
  type        = number
  default     = 2
}

variable "desired_size" {
  description = "Desired size of the EKS node group"
  type        = number
  default     = 1
}

variable "ami_type" {
  description = "The AMI type for EKS nodes"
  type        = string
  default     = "AL2_x86_64"
}

variable "github_repo" {
  description = "GitHub repository associated with the project"
  type        = string
  default     = "github.com/demo/repo"
}
