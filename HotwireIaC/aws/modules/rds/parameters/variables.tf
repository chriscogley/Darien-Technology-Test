variable "rds_name" {
  description = "Name of the RDS"
  type = string
  default = ""
}

variable "rds_family" {
  description = "Family used by the RDS"
  type = string
  default = ""
}

variable "rds_parameter_name" {
  description = "Parameter name"
  type = string
  default = ""
}

variable "rds_parameter_value" {
  description = "Parameter value"
  type = string
  default = ""
}

variable "rds_parameter_apply_method" {
  description = "immediate (default) or pending-reboot. When to apply the update"
  type = string
  default = ""
}