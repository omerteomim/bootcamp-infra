# Bootcamp infrastructure

This repository contains the infrastructure code of the bootcamp project. The application code for the Psychometry App. is located in the [bootcamp-project](https://github.com/omerteomim/bootcamp-project) repository, and the GitOps configurations are in the [bootcamp-gitops](https://github.com/omerteomim/bootcamp-gitops) repository.

## AWS EKS Terraform Infrastructure

This repository contains Terraform code to provision an AWS EKS cluster and its surrounding infrastructure. It is designed to be modular and reusable for different environments.

## Overview

This project provisions the following resources:

*   **VPC:** A custom Virtual Private Cloud (VPC) with public and private subnets.
*   **EKS:** An Amazon Elastic Kubernetes Service (EKS) cluster.
*   **ALB:** An AWS Application Load Balancer (ALB) Ingress Controller for exposing services.
*   **ArgoCD:** A declarative, GitOps continuous delivery tool for Kubernetes.
*   **Monitoring:** A monitoring stack using Prometheus and Grafana.
*   **External Secrets:** A Kubernetes operator that integrates with external secret management systems like AWS Secrets Manager.

## Prerequisites

Before you begin, ensure you have the following tools installed:

*   [Terraform](https://www.terraform.io/downloads.html)
*   [AWS CLI](https://aws.amazon.com/cli/)
*   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

You will also need to have your AWS credentials configured.

## Project Structure

The repository is structured as follows:

```
.
├── environments/
│   ├── dev/
│   ├── prod/
│   └── staging/
├── modules/
│   ├── alb/
│   ├── argocd/
│   ├── eks/
│   ├── eso-irsa/
│   ├── externalsecrets/
│   ├── monitoring/
│   └── vpc/
├── deploy_infra.sh
├── destroy_infra.sh
└── README.md
```

*   **`environments/`**: Contains the Terraform configurations for each environment (e.g., `dev`, `staging`, `prod`). Each environment has its own `main.tf`, `variables.tf`, and `terraform.tfvars`.
*   **`modules/`**: Contains reusable Terraform modules for each component of the infrastructure.
*   **`deploy_infra.sh`**: A script to deploy the infrastructure for a specific environment.
*   **`destroy_infra.sh`**: A script to destroy the infrastructure for a specific environment.

## Usage

### Deploying the Infrastructure

To deploy the infrastructure for a specific environment, run the `deploy_infra.sh` script with the environment name as an argument.

For example, to deploy the `dev` environment:

```bash
./deploy_infra.sh dev
```

This script will:
1.  Initialize Terraform.
2.  Apply the Terraform configuration to create the infrastructure.
3.  Update your kubeconfig to connect to the new EKS cluster.
4.  Apply an ArgoCD ApplicationSet.
5.  Create a Route53 CNAME record for the application URL.

### Destroying the Infrastructure

To destroy the infrastructure for a specific environment, run the `destroy_infra.sh` script with the environment name as an argument.

For example, to destroy the `dev` environment:

```bash
./destroy_infra.sh dev
```

This script will:
1.  Delete the Route53 CNAME record.
2.  Run `terraform destroy` to tear down all the infrastructure.

## Terraform Modules

*   **`vpc`**: Creates the VPC, subnets, NAT gateways, and other networking resources.
*   **`eks`**: Provisions the EKS cluster, including the control plane and worker nodes.
*   **`alb`**: Deploys the AWS Load Balancer Controller to the EKS cluster.
*   **`argocd`**: Installs ArgoCD on the cluster for GitOps.
*   **`monitoring`**: Sets up Prometheus and Grafana for monitoring the cluster and applications.
*   **`eso-irsa`**: Creates the IAM role for External Secrets Operator.
*   **`externalsecrets`**: Deploys the External Secrets Operator.
