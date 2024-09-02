// *** Resource Group ***
rg_name     = "aks-acr-deployment-project"
rg_location = "southeastasia"

// *** Azure Container Registery (ACR) ***
acr_name = "sd4413-devops-for-dev"
sku      = "Premium"
admin_enabled                 = true
public_network_access_enabled = true

// *** Azure Kubernetes Service (AKS) ***
kubernetes_cluster_name = "sd4413-cluster"
dns_prefix              = "sd4413"
//default_node_pool
default_node_pool_name       = "app"
default_node_pool_node_count = 1
default_node_pool_vm_size    = "Standard_D2as_v4"
// identity
identity_type = "SystemAssigned"


// *** Role Assignment to connect ACR and AKS together ***
role_definition_name             = "AcrPull"
skip_service_principal_aad_check = true