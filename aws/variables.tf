variable "vnet_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "vpc_tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the VPC."
}

variable "public_subnet_cidr" {
  type        = list(string)
  default     = []
  description = "CIDR blocks for public subnets."
}

variable "private_subnet_cidr" {
  type        = list(string)
  default     = []
  description = "CIDR blocks for private subnets."
}

variable "subnet_azs" {
  type        = list(string)
  default     = null
  description = "Availability zones for subnets."
}

variable "public_subnet_tags" {
  type        = map(string)
  default     = {}
  description = "Tags for public subnets."
}

variable "private_subnet_tags" {
  type        = map(string)
  default     = {}
  description = "Tags for private subnets."
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
}

variable "aws_ecr_repository" {
  type        = string
  description = "Name of the ECR repository."
}

variable "eks_public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR blocks that can access the EKS API server."
}