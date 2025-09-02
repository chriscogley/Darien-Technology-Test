########## VPC ##########

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = ""
}

variable "vpc_block" {
  description = "VPC CIDR Block"
  type = string
  default = ""
}

# variable "vpc_netmask" {
#   description = "VPC Netmask Lenght"
#   type        = number
#   #  default = ""
# }

variable "vpc_flow_log_name" {
  description = "Name for the VPC Flow Log"
  type        = string
  default     = ""
}

variable "vpc_flow_log_destination" {
  description = "VPC Flow Log Destination"
  type        = string
  default     = ""
}

variable "vpc_flow_log_type" {
  description = "VPC Flow Log type"
  type        = string
  default     = ""
}


########## SUBNETS ##########

variable "public_subnets_az" {
  description = "List of public subnets Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets_az" {
  description = "List of private subnets Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "subnet_netmask" {
  description = "Netmask used by the subnets"
  type        = number
  #  default = ""
}

variable "subnet_qty" {
  description = "Quantity of subnets in total"
  type        = number
  #  default = ""
}

variable "public_subnets_qty" {
  description = "Quantity of public subnets"
  type        = number
  #  default = ""
}

variable "private_subnets_qty" {
  description = "Quantity of private subnets"
  type        = number
  #  default = ""
}

########## NAT GATEWAY ##########

########## INTERNET GATEWAY ##########

########## NETWORK ACL ##########

#variable "nacl_protocol" {
#  description = ""
#  type = string
#  default = ""
#}
#
#variable "nacl_action" {
#  description = ""
#  type = string
#  default = ""
#}
#
#variable "nacl_number" {
#  description = ""
#  type = number
#  default = ""
#}
#
#variable "nacl_egress" {
#  description = ""
#  type = bool
#  default = ""
#}
#
#variable "nacl_cidr_block" {
#  description = ""
#  type = string
#  default = ""
#}
#
#variable "nacl_from_port" {
#  description = ""
#  type = number
#  default = ""
#}
#
#variable "nacl_to_port" {
#  description = ""
#  type = number
#  default = ""
#}

########## VPC ENDPOINT ##########

########## ROUTE TABLES ##########






