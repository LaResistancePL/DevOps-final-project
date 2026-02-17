variable "namespace" { type = string default = "argocd" }
variable "chart_version" { type = string default = "7.6.12" }
variable "charts_repo_url" { type = string }
variable "charts_repo_path" { type = string }
variable "tags" { type = map(string) default = {} }
