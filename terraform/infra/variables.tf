variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "selar"
}

variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
  default     = "selar-api"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "selar-eks-prod"
}


variable "app_name" {
  description = "Application name"
  type        = string
  default     = "selar-api"
}

variable "local_image_name" {
  description = "Local Docker image used in Minikube"
  type        = string
  default     = "selar-api:prod"
}
