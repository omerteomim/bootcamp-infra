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