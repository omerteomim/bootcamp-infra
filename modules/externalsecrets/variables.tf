variable "external_secrets_role_arn" {
  description = "IAM role ARN for External Secrets Operator IRSA"
  type        = string
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