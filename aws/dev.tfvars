# VPC Configuration
vnet_cidr_block = "10.0.0.0/16"
vpc_tags = {
  Name = "my-vpc"
}

# Subnet Configuration
public_subnet_cidr = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidr = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

subnet_azs = [
  "us-east-1a",
  "us-east-1b"
]

public_subnet_tags = {
  Name = "public-subnet"
}

private_subnet_tags = {
  Name = "private-subnet"
}

# EKS Configuration
aws_ecr_repository = "sd4413-practical-devop"
eks_cluster_name = "sd4413-devop-for-dev"
eks_public_access_cidrs = ["0.0.0.0/0"]
