# GOIT DevOps Final Project

## Architecture Overview

- **Networking:** custom AWS VPC with public and private subnets across two Availability Zones
- **Compute:** Amazon EKS managed node group for Kubernetes workloads
- **Registry:** Amazon ECR repository for application container images
- **Database:** Amazon RDS MySQL instance for Django persistence
- **CI:** Jenkins deployed via Helm into Kubernetes
- **CD / GitOps:** Argo CD deployed via Helm and configured to watch the application chart
- **Monitoring:** kube-prometheus-stack with Prometheus and Grafana
- **Application:** sample Django application deployed via Helm chart

## Repository Structure

- `bootstrap/backend/` — bootstrap stack for Terraform state backend (S3 + DynamoDB)
- `modules/` — reusable Terraform modules for AWS and Kubernetes platform components
- `charts/django-app/` — Helm chart used to deploy the sample application
- `Django/` — sample Django application, Dockerfile, requirements, Jenkinsfile
- `backend.hcl.example` — example backend configuration for S3 remote state
- `terraform.tfvars.example` — example project variables

## Deployment Sequence

### 1. Bootstrap the Terraform backend

```bash
cd bootstrap/backend
terraform init
terraform apply
```

Use the outputs from the bootstrap stack to create `backend.hcl` from `backend.hcl.example`.

### 2. Prepare example variable files

```bash
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars
```

Update the example values as needed for a specific AWS account, Git repository branch, and target environment before a live deployment.

### 3. Initialize and apply the root project

```bash
terraform init -backend-config=backend.hcl -reconfigure
terraform plan
terraform apply
```

### 4. Configure local kubectl context

```bash
aws eks update-kubeconfig --region eu-central-1 --name $(terraform output -raw eks_cluster_name)
```

### 5. Verify platform namespaces

```bash
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring
```

### 6. Access key services with port-forwarding

```bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
kubectl port-forward svc/argocd-server 8081:443 -n argocd
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring
```

## Expected CI/CD Flow

1. A code change is pushed to the Git repository.
2. Jenkins checks out the repository and builds a Docker image for the Django app.
3. Jenkins tags and pushes the image to Amazon ECR.
4. Jenkins updates the Helm chart image tag in `charts/django-app/values.yaml`.
5. Argo CD detects the Git change and synchronizes the application into EKS.
6. Prometheus scrapes application metrics from `/metrics` and Grafana visualizes them.


## Clean Up

```bash
terraform destroy
```

