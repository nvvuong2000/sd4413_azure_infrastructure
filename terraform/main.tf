terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  tenant_id = ""
  client_id = ""
  subscription_id = ""
  features {}
}

module "resource_group" {
  source               = "./modules/resource_group"
  name      = var.resource_group_name
  location  = var.location
}

module "network" {
  source              = "./modules/network"
  vnet_name           = var.vnet_name
  subnet_name         = var.subnet_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  depends_on = [module.resource_group]
}

module "acr" {
  source              = "./modules/acr"
  acr_name            = var.acr_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  depends_on = [module.resource_group]
}

module "aks" {
  source              = "./modules/aks"
  cluster_name        = var.aks_cluster_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.network.subnet_id
  acr_id              = module.acr.acr_id
  node_count         = var.node_count
  vm_size            = var.vm_size
  depends_on = [module.resource_group, module.network, module.acr]
}
