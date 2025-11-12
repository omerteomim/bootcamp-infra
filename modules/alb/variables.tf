variable "alb_controller_version" {
  description = "Version of AWS Load Balancer Controller"
  type        = string
  default     = "1.8.1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "environment" {
  description = "environment"
  type = string
}

variable "alb_zone_id" {
    description = "Route53 Hosted Zone ID for ALB"
    type        = string
    default = "Z35SXDOTRQ7X7K"
  
}