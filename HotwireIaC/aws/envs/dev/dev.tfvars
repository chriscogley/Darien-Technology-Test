#provider.tf
provider_region       = "us-east-1"
provider_config_files = "/Users/chris/.aws/config"
provider_creds        = "/Users/chris/.aws/credentials"
provider_profile      = "fng-dev"

tag_environment = "Dev"
tag_project     = "fng"
tag_owner       = "Hotwire"
tag_dev         = "AttomLab"

#vpc.tf
vpc_name                = "fng-dev"
vpc_block               = "10.192.0.0/22"
vpc_flow_log_name       = "fng-dev-flow"
vpc_subnet_netmask      = 26
vpc_subnet_qty          = 6
vpc_public_subnets_qty  = 3
vpc_private_subnets_qty = 3

#eks.tf
eks_cluster_name    = "fng-dev"
eks_cluster_version = "1.33"
eks_admin_cidrs     = ["190.218.155.43/32"]
eks_iam_principal = "arn:aws:iam::927588815039:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_pset-fnng-devops-dev_b9479c436d0da929"