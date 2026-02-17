# Final Project — AWS DevOps Automation (Terraform + EKS + Jenkins + Argo CD + Monitoring)

This repository is a **ready-to-fill template** matching the required course structure.

## What this template includes
- Terraform root wiring with module stubs for:
  - S3 backend (state bucket + DynamoDB lock)
  - VPC
  - ECR
  - EKS (+ optional EBS CSI add-on placeholder)
  - RDS/Aurora (switchable)
  - Jenkins (Helm)
  - Argo CD (Helm) + GitOps "apps" chart scaffold
  - Monitoring (Prometheus + Grafana via Helm; kube-prometheus-stack)
- Helm chart scaffold for a Django app
- Django app folder scaffold with Dockerfile + Jenkinsfile placeholders

> ⚠️ This is a **template**. You must fill variables (names, CIDRs, Git repo URLs, secrets),
> and adjust versions (EKS, Helm charts) to match your environment.

## Quick start (suggested workflow)

### 1) Create backend first (recommended)
1. `cd modules/s3-backend`
2. `terraform init`
3. `terraform apply`
4. Copy outputs (bucket + table names) into **root** `backend.tf`

### 2) Deploy the full infra
1. From repo root:
   - `terraform init -reconfigure`
   - `terraform apply`
2. Configure kubeconfig:
   - `aws eks update-kubeconfig --region <REGION> --name <CLUSTER_NAME>`

### 3) Verify namespaces
- `kubectl get all -n jenkins`
- `kubectl get all -n argocd`
- `kubectl get all -n monitoring`

### 4) Port-forward checks
- Jenkins:
  - `kubectl port-forward svc/jenkins 8080:8080 -n jenkins`
- Argo CD:
  - `kubectl port-forward svc/argocd-server 8081:443 -n argocd`
- Grafana:
  - `kubectl port-forward svc/grafana 3000:80 -n monitoring`

### 5) Destroy (avoid costs)
- `terraform destroy`

> When you destroy everything, you also remove S3/DynamoDB used for state (unless you keep them separately).

## Repository structure
Matches the provided course structure (modules/, charts/, Django/).

---
If you want, replace placeholders with your real values and run apply. 
