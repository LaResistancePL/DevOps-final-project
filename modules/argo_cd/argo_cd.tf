resource "kubernetes_namespace" "this" {
  metadata { name = var.namespace }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  values     = [file("${path.module}/values.yaml")]
  depends_on = [kubernetes_namespace.this]
}

# Initial admin password secret
data "kubernetes_secret" "initial" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = var.namespace
  }
  depends_on = [helm_release.argocd]
}

# GitOps Application (points to your charts repo)
resource "kubernetes_manifest" "app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "django-app"
      namespace = var.namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.charts_repo_url
        targetRevision = "main"
        path           = var.charts_repo_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
  depends_on = [helm_release.argocd]
}
