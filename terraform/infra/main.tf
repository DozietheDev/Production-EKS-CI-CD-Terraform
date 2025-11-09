module "vpc" {
  source = "../modules/vpc"
  name   = var.project_name
}

module "iam" {
  source      = "../modules/iam"
  project     = var.project_name
  eks_cluster = var.eks_cluster_name
}

module "ecr" {
  source        = "../modules/ecr"
  repository    = var.ecr_repo_name
  force_delete  = true
}

module "eks" {
  source             = "../modules/eks"
  cluster_name       = var.eks_cluster_name
  cluster_role_arn   = module.iam.eks_role_arn
  subnet_ids         = module.vpc.public_subnets
  vpc_id             = module.vpc.vpc_id
  desired_size       = 2
  max_size           = 3
  min_size           = 1
}

# --- Local Minikube Deployment (optional) ---
module "local_k8s" {
  source = "../modules/local-k8s"

  app_name         = var.app_name
  image_name       = var.local_image_name
  replicas         = 2
  namespace        = "selar-local"
  container_port   = 8080
}
