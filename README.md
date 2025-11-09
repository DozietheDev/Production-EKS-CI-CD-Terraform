# Selar APP Deployment

This repository contains infrastructure and deployment configurations for the **Selar APP**.  
The application runs as a containerized workload deployed to **Amazon EKS** using **Terraform** for infrastructure provisioning and **Kubernetes manifests** for deployment and ingress exposure.

---

## 🚀 Project Overview

### Core Stack
- **Backend**: Python-based microservice (`selar-api:prod`)
- **Containerization**: Docker
- **Infrastructure**: Terraform + AWS EKS
- **CI/CD**: GitHub Actions
- **Ingress**: NGINX Ingress Controller with Let’s Encrypt (cert-manager)
- **Observability**: Prometheus, Fluent Bit, Cloudwatch, Grafana, Loki
- **Secret Management**: AWS Secrets Manager / Kubernetes Secrets

---

## ⚙️ Setup Instructions

[A] Local Development (Minikube)

If you want to run the service locally:

#### Prerequisites
- [Docker](https://docs.docker.com/)
- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)

#### Steps

```bash
# Start minikube
minikube start --driver=docker

# Build and tag image locally
docker build -t selar-api:local .

# Deploy using local Terraform module
cd terraform/infra
terraform init
terraform apply -var="env=local"

# Apply Kubernetes manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/ingress.yaml

# Access locally:
minikube service selar-app-service


[B] Cloud Deployment (AWS EKS)
Prerequisites:
AWS CLI configured with admin credentials
Terraform installed (>=1.6.0)
kubectl configured for your EKS cluster

Steps
# Navigate to the infra folder
cd terraform/infra

# Initialize Terraform
terraform init

# Create infrastructure
terraform apply -auto-approve

# Get EKS credentials
aws eks --region <region> update-kubeconfig --name <eks_cluster_name>

# Deploy application
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/ingress.yaml


SSL Certificates (Let’s Encrypt)
The ingress is secured using cert-manager with Let’s Encrypt.
Apply ClusterIssuer:
kubectl apply -f k8s/clusterissuer.yaml
Apply Certificate:
kubectl apply -f k8s/certificate.yaml



[C] Observability Setup
Prometheus & Grafana:
# Install using Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

Access Grafana:
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
URL: http://localhost:3000
Default login: admin / prom-operator


Loki (Log Aggregation):
helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install loki grafana/loki-stack -n monitoring


[D] CI/CD Workflow (GitHub Actions)

The .github/workflows/deploy.yml automates:
Building and pushing the Docker image (selar-api:prod) to ECR.
Applying Terraform to provision/update AWS infrastructure.
Deploying to EKS via kubectl.
Trigger:
Pushing to main branch → deploys to production.

# Cleanup
To tear down infrastructure:
cd terraform/infra
terraform destroy -auto-approve

# Notes
Always tag your production image (selar-api:prod) explicitly — avoid latest.
Store secrets securely in AWS Secrets Manager or Kubernetes Secrets.
Ensure your domain DNS points to the Load Balancer created by the Nginx ingress.



Author:
Dozie Martins
Senior DevOps Engineer