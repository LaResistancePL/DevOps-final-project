resource "kubernetes_namespace" "this" {
  metadata { name = var.namespace }
}

resource "helm_release" "kps" {
  name       = "kube-prometheus-stack"
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  values = [file("${path.module}/values.yaml")]

  depends_on = [kubernetes_namespace.this]
}

# Read grafana admin password from the chart's secret (if default behavior creates it).
# With our values.yaml, adminPassword is set explicitly to "admin" for demo purposes.
