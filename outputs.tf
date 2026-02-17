output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "rds_endpoint" {
  value = module.rds.endpoint
  sensitive = false
}

output "jenkins_admin_password" {
  value     = module.jenkins.admin_password
  sensitive = true
}

output "argocd_initial_admin_password" {
  value     = module.argo_cd.initial_admin_password
  sensitive = true
}

output "grafana_admin_password" {
  value     = module.monitoring.grafana_admin_password
  sensitive = true
}
