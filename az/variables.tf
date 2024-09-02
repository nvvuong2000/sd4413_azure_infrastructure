variable "rg_name" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "acr_name" {
  description = ""
  type        = string
}
variable "sku" {
  description = ""
  type        = string
}
variable "kubernetes_cluster_name" {
  description = ""
  type        = string
}
variable "dns_prefix" {
  description = ""
  type        = string
}
variable "default_node_pool_name" {
  description = ""
  type        = any
}
variable "default_node_pool_node_count" {
  description = ""
  type        = number
}
variable "default_node_pool_vm_size" {
  description = ""
  type        = string
}
variable "identity_type" {
  description = ""
  type        = string
}
variable "skip_service_principal_aad_check" {
  type = bool
}