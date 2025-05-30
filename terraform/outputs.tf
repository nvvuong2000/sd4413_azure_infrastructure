output "aks_name" {
  value = module.aks.name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "aks_kubeconfig" {
  value     = module.aks.kube_config
  sensitive = true
}