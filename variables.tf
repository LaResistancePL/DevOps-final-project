variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "project_name" {
  type        = string
  description = "Project name prefix"
  default     = "final-devops"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}

# VPC
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# EKS
variable "cluster_version" {
  type        = string
  default     = "1.29"
}

variable "node_instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
}

# RDS
variable "db_use_aurora" {
  type        = bool
  default     = false
}

variable "db_engine" {
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.micro"
}

variable "db_multi_az" {
  type        = bool
  default     = false
}

variable "db_username" {
  type        = string
  default     = "admin"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Set via terraform.tfvars (do not commit)."
}

# GitOps / repos
variable "charts_repo_url" {
  type        = string
  description = "Git repo URL where Helm charts are stored (for Argo CD app)."
  default     = "https://github.com/REPLACE_ME/REPLACE_ME.git"
}

variable "charts_repo_path" {
  type        = string
  description = "Path within repo to the chart (e.g. charts/django-app)."
  default     = "charts/django-app"
}
