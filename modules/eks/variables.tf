variable "environment" {
    description = "name of environment"
    type = string
}

variable "kubernetes_version" {
    description = "Kubernetes version for the EKS cluster"
    type = string
    default = "1.33"
}

variable "vpc_id" {
    description = "The ID of the VPC where the EKS cluster will be deployed"
    type = string
}

variable "private_subnets" {
    description = "List of private subnet IDs for the EKS cluster"
    type = list(string)
}

variable "public_subnets" {
    description = "List of public subnet IDs for the EKS cluster"
    type = list(string)
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