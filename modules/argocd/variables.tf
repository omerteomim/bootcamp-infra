variable "argocd_version" {
  description = "Version of ArgoCD"
  type        = string
  default     = "7.3.0"
}

variable "argocd_insecure" {
  description = "Disable internal TLS for ArgoCD server"
  type        = bool
  default     = false
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

variable "cluster_name" {
  description = "Name of the EKS cluster (for dependency tracking)"
  type        = string
  default     = ""
}

