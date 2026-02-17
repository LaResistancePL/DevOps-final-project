resource "kubernetes_namespace" "this" {
  metadata { name = var.namespace }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = var.namespace
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version

  values = [file("${path.module}/values.yaml")]

  depends_on = [kubernetes_namespace.this]
}

# Get initial admin password from the secret created by the chart
data "kubernetes_secret" "admin" {
  metadata {
    name      = "jenkins"
    namespace = var.namespace
  }
  depends_on = [helm_release.jenkins]
}
