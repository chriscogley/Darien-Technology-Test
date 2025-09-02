variable "dns_zone_name" {
  description = "DNS Zone name"
  type        = string
  default     = ""
}

variable "zone_comment" {
  description = "Comment for the hosted zone"
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  default     = ""
}

variable "vpc_region" {
  description = "Region of the VPC"
  type        = string
  default     = "us-east-1"
}