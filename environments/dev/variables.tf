variable "environment" {
    description = "name of environment"
    type = string
}

variable "cidr" {
    description = "cidr for vpc"
    type = string
}

variable "azs" {
    description = "list of azs"
    type = list(string)
    default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
    description = "list of private_subnets"
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
    description = "list of public_subnets"
    type = list(string)
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "region" {
    description = "AWS region"
    type = string
    default = "us-east-1"
}

variable "ami_type" {
    description = "The AMI type for the EKS managed node group"
    type = string
    default = "AL2023_x86_64_STANDARD"
}

variable "instance_types" {
    description = "List of instance types for the EKS managed node group"
    type = list(string)
    default = ["t3.small"]
}

variable "desired_capacity" {
    description = "Desired number of worker nodes in the EKS managed node group"
    type = number
    default = 1
}

variable "max_size" {
    description = "Maximum number of worker nodes in the EKS managed node group"
    type = number
    default = 2
}

variable "min_size" {
    description = "Minimum number of worker nodes in the EKS managed node group"
    type = number
    default = 1
}

variable "kubernetes_version" {
    description = "Kubernetes version for the EKS cluster"
    type = string
    default = "1.33"
}

variable "admin_pass" {
    description = "Admin password for ArgoCD"
    type = string
}

variable "gitops_repo" {
    description = "URL of the GitOps repository"
    type = string
}

variable "grafana_admin_password" {
    description = "Admin password for Grafana"
    type = string
}

variable "external_secrets_version" {
  description = "Version of External Secrets Operator"
  type        = string
  default     = "v0.9.20"
}

variable "external_secrets_namespace" {
  description = "Namespace for External Secrets Operator"
  type        = string
  default     = "external-secrets"
}

variable "argocd_version" {
  description = "Version of ArgoCD"
  type        = string
  default     = "7.3.0"
}

variable "argocd_insecure" {
  description = "Disable internal TLS for ArgoCD server"
  type        = bool
  default     = true
}

variable "argocd_service_type" {
  description = "Service type for ArgoCD server"
  type        = string
  default     = "ClusterIP"
}

variable "argocd_controller_replicas" {
  description = "Number of ArgoCD controller replicas"
  type        = number
  default     = 1
}