terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  default_tags {
    tags = {
      Course = "Practical DevOps"
    }
  }
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vnet_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = var.vpc_tags
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.subnet_azs[count.index]
  tags = var.public_subnet_tags
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.subnet_azs[count.index]
  tags = var.private_subnet_tags
}

# Internet Gateway and Route Table
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.route.id
}

# ECR Repositories
resource "aws_ecr_repository" "backend" {
  name = "ntg-garage-backend"
}

resource "aws_ecr_repository" "frontend" {
  name = "ntg-garage-frontend"
}

# EKS Cluster
data "aws_iam_role" "eks_service_role" {
  name = "AmazonEKSClusterRole"
}

resource "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
  role_arn = data.aws_iam_role.eks_service_role.arn
  vpc_config {
    subnet_ids = aws_subnet.public.*.id
    public_access_cidrs = var.eks_public_access_cidrs
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name = aws_eks_cluster.eks.name
  node_group_name = "nodegroup"
  node_role_arn = data.aws_iam_role.eks_worker_role.arn
  scaling_config {
    desired_size = 1
    max_size = 2
    min_size = 0
  }
  subnet_ids = aws_subnet.public.*.id
  ami_type = "AL2023_x86_64_STANDARD"
  disk_size = 8
  capacity_type = "SPOT"
  instance_types = ["t3.medium"]
}

# Helm Releases (Commented Out)
# resource "helm_release" "prometheus" {
#   ...
# }
# resource "helm_release" "grafana" {
#   ...
# }
