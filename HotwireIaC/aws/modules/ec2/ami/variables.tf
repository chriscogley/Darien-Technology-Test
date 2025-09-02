variable "ami_name" {
  description = ""
  type        = string
  default     = ""
}
variable "ami_description" {
  description = ""
  type        = string
  default     = ""
}
variable "ami_architecture" {
  description = ""
  type        = string
  default     = ""
}
variable "ami_virtualization_type" {
  description = ""
  type        = string
  default     = ""
}
variable "ami_root_name" {
  description = ""
  type        = string
  default     = ""
}
variable "ami_imds_support" {
  description = ""
  type        = string
  default     = ""
}

###### EBS

variable "ebs_device_name" {
  description = ""
  type        = string
  default     = ""
}
variable "ebs_snapshot_id" {
  description = ""
  type        = string
  default     = ""
}
variable "ebs_volume_size" {
  description = ""
  type        = string
  default     = ""
}
variable "ebs_volume_type" {
  description = ""
  type        = string
  default     = ""
}
variable "ebs_throughput" {
  description = ""
  type        = string
  default     = ""
}
variable "ebs_iops" {
  description = ""
  type        = string
  default     = ""
}
variable "ebs_encrypted" {
  description = ""
  type        = string
  default     = ""
}
variable "ebs_delete_on_termination" {
  description = ""
  type        = string
  default     = ""
}