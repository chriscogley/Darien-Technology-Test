variable "sg_name" {
  description = "Security Group Name"
  type        = string
  default     = ""
}
variable "sg_description" {
  description = "Securiy Group Description"
  type        = string
  default     = ""
}
variable "sg_vpc" {
  description = "VPC where you can use the Security Group"
  type        = string
  default     = ""
}