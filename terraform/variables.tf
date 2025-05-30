variable "resource_group_name" {
  default = "myResourceGroup"
}

variable "location" {
  default = "southeastasia"
}

variable "vnet_name" {
  default = "myVNet"
}

variable "subnet_name" {
  default = "myAKSSubnet"
}

variable "acr_name" {
  default = "myacr12345"
}

variable "aks_cluster_name" {
  default = "myAKSCluster"
}
variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "Size of the VM for nodes"
  type        = string
  default     = "Standard_D2s_v3"
}