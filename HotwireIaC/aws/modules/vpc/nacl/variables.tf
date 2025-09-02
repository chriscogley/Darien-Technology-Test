variable "network_acl_id" {
  description = "NACL id"
  type        = string
  default     = ""
}

variable "egress" {
  description = "Indicates wheter this is an egress rule"
  type        = bool
  default     = "false"
}

variable "protocol" {
  description = "The protocol. TCP/UDP. -1 means all protocols"
  type        = string
  default     = ""
}

variable "rule_action" {
  description = "Indicates whether to allow or deny traffic"
  type        = string
  default     = "deny"
}

variable "rule_number" {
  description = "Number for the entry. ACL entries are processed in ascending order by rule number."
  type        = number
  default     = ""
}

variable "cidr_block" {
  description = "Network Range to allow or deny. CIDR notation"
  type        = string
  default     = ""
}

variable "from_port" {
  description = "From port to match"
  type        = number
  default     = ""
}

variable "to_port" {
  description = "To port to match"
  type        = number
  default     = ""
}
