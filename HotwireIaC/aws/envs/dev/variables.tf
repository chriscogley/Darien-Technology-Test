# provider.tf
variable "provider_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "provider_config_files" {
  description = "Shared AWS config files"
  type        = string
}

variable "provider_creds" {
  description = "AWS Credentials"
  type        = string
}

variable "provider_profile" {
  description = "AWS Profile"
  type        = string
}

variable "tag_environment" {
  description = "Environment Tag"
  type        = string
}

variable "tag_project" {
  description = "What project it is"
  type        = string
}

variable "tag_owner" {
  description = "Who is the owner of the project"
  type        = string
}

variable "tag_dev" {
  description = "Who is the developer of the project"
  type        = string
}

############

#vpc.tf
variable "vpc_name" {}
variable "vpc_block" {}
variable "vpc_flow_log_name" {}
variable "vpc_subnet_netmask" {}
variable "vpc_subnet_qty" {}
variable "vpc_public_subnets_qty" {}
variable "vpc_private_subnets_qty" {}

############

#eks.tf
variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "fng-dev"
}

variable "eks_cluster_version" {
  description = "EKS version"
  type        = string
  default     = "1.33"
}

variable "eks_admin_cidrs" {
  description = "CIDRs allowed to reach the EKS public API endpoint"
  type        = list(string)
  default     = ["190.218.155.43/32"] # tighten to your IPs
}

variable "eks_iam_principal" {
  description = "Role used to admin Cluster"
  type = string
}

############

variable "route53_zone_id" {
  description = "Public Route53 Hosted Zone ID for hw-fng.com (e.g., Z123ABC...)"
  type        = string
  default     = "Z04582493GYYDVH4AGAVQ"
}

# variable "domain" {
#   description = "Base DNS domain"
#   type        = string
#   default     = "hw-fng.com"
# }
#
# variable "lb_dns_name" {
#   description = "DNS name of the ingress-nginx NLB (e.g., a1b2c3d4e5f6g7h8.elb.us-east-1.amazonaws.com)"
#   type        = string
#   default     = ""
# }
#
# variable "lb_zone_id" {
#   description = "Canonical hosted zone ID of the NLB (aws elbv2 describe-load-balancers -> CanonicalHostedZoneId)"
#   type        = string
#   default     = ""
# }
