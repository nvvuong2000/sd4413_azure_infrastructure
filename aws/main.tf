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
  region = "us-east-1"
  default_tags {
    tags = {
        Course = "sd4413-devops-for-dev"
    }
  }
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vnet_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = var.vpc_tags
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_azs[count.index]
  tags                    = var.public_subnet_tags
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.subnet_azs[count.index]
  tags              = var.private_subnet_tags
}

# Internet Gateway and Route Table
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.route.id
}

# ECR Repositories
resource "aws_ecr_repository" "backend" {
  name = var.aws_ecr_repository
}

resource "aws_ecr_repository" "frontend" {
  name = var.aws_ecr_repository
}

# IAM Role for EKS Worker Nodes
resource "aws_iam_role" "eks_worker_role" {
  name = "AmazonEKSWorkerNodeRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to IAM role (example, adjust as needed)
resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# EKS Cluster

resource "aws_eks_cluster" "eks" {
  name     = var.eks_cluster_name
  vpc_config {
    subnet_ids              = aws_subnet.public.*.id
    public_access_cidrs     = var.eks_public_access_cidrs
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "nodegroup"

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }

  subnet_ids    = aws_subnet.public.*.id
  ami_type      = "AL2023_x86_64_STANDARD"
  disk_size     = 8
  capacity_type = "SPOT"
  instance_types = ["t3.medium"]
}
