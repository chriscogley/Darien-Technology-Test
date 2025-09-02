variable "rds_name" {
  description = "Name of the RDS Instance"
  type = string
  default = ""
}

variable "rds_subnets" {
  description = "List of subnets"
}