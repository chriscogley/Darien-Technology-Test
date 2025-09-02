variable "sg_description" {
  description = "Description of the Security Group"
  type        = string
  default     = ""
}
#variable "sg_from_port" {
#  description = "Start port."
#  type        = number
#}
#variable "sg_to_port" {
#  description = "End port "
#  type        = number
#}
variable "sg_protocol" {
  description = "Protocol. tcp,udp,icmp,icmpv6 or protocol number"
  type        = string
  default     = ""
}
variable "sg_id" {
  description = "Security group to apply this rule to."
  type        = string
  default     = ""
}
variable "sg_type" {
  description = " Type of rule being created. ingress (for inbound) or egress (for outbound)"
  type        = string
  default     = ""
}

variable "sg_cidr_blocks" {
  description = "List of CIDR blocks."
  type        = list(string)
  default     = null
}
variable "sg_ports" {
  description = "List of Ports"
  type        = list(string)
  default     = null
}

variable "sg_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR blocks."
  type        = list(string)
  default     = null
}
variable "sg_self" {
  description = "Whether the security group itself will be added as a source to this ingress rule."
  type        = bool
  default     = null
}
variable "sg_source_sg_id" {
  description = "Security group id to allow access to/from, depending on the type"
  type        = string
  default     = null
}