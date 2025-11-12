module "vpc" {
    source = "../../modules/vpc"
    environment = var.environment
    cidr = var.cidr
    azs = var.azs
    private_subnets = var.private_subnets
    public_subnets = var.public_subnets
}

module "eks" {
    source = "../../modules/eks"
    environment = var.environment
    kubernetes_version = var.kubernetes_version
    vpc_id = module.vpc.vpc_id
    private_subnets = module.vpc.private_subnets
    public_subnets = module.vpc.public_subnets
    ami_type = var.ami_type
    instance_types = var.instance_types
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity
    depends_on = [ module.vpc ]
}

module "eso-irsa" {
    source = "../../modules/eso-irsa"
    oidc_provider_arn = module.eks.oidc_provider_arn
    depends_on = [ module.eks ] 
}

module "alb" {
    source = "../../modules/alb"
    environment = var.environment
    cluster_name = module.eks.cluster_name
    vpc_id = module.vpc.vpc_id
    oidc_provider_arn = module.eks.oidc_provider_arn
    depends_on = [ module.eks ]
}

module "monitoring" {
    source = "../../modules/monitoring"
    grafana_admin_password = var.grafana_admin_password
    depends_on = [ module.eks, module.alb ]
}

module "external-secrets" {
    source = "../../modules/externalsecrets"
    external_secrets_namespace = var.external_secrets_namespace
    external_secrets_version    = var.external_secrets_version
    external_secrets_role_arn   = module.eso-irsa.external_secrets_role_arn
    depends_on = [ module.eks, module.eso-irsa, module.alb ]
}

module "argocd" {
    source = "../../modules/argocd"
    cluster_name = module.eks.cluster_name
    argocd_insecure          = var.argocd_insecure
    argocd_service_type      = var.argocd_service_type
    argocd_version           = var.argocd_version
    argocd_controller_replicas = var.argocd_controller_replicas
    depends_on = [ module.eks, module.alb]
}