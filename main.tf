module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region           = var.aws_region
  tags                 = var.tags
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  tags         = var.tags
}

module "eks" {
  source            = "./modules/eks"
  project_name      = var.project_name
  cluster_version   = var.cluster_version
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  node_instance_types = var.node_instance_types
  tags              = var.tags
}

module "rds" {
  source         = "./modules/rds"
  project_name   = var.project_name
  use_aurora     = var.db_use_aurora
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  multi_az       = var.db_multi_az

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  db_name   = "appdb"
  username  = var.db_username
  password  = var.db_password

  allowed_cidrs = [var.vpc_cidr] # adjust as needed
  tags          = var.tags
}

# Jenkins (Helm)
module "jenkins" {
  source       = "./modules/jenkins"
  namespace    = "jenkins"
  chart_version = "5.8.12" # adjust if needed
  tags         = var.tags
  depends_on   = [module.eks]
}

# Argo CD (Helm + an Application manifest scaffold)
module "argo_cd" {
  source         = "./modules/argo_cd"
  namespace      = "argocd"
  chart_version  = "7.6.12" # adjust if needed
  charts_repo_url  = var.charts_repo_url
  charts_repo_path = var.charts_repo_path
  tags           = var.tags
  depends_on     = [module.eks]
}

# Monitoring (Prometheus + Grafana)
module "monitoring" {
  source        = "./modules/monitoring"
  namespace     = "monitoring"
  chart_version = "58.6.0" # kube-prometheus-stack chart version placeholder
  tags          = var.tags
  depends_on    = [module.eks]
}
