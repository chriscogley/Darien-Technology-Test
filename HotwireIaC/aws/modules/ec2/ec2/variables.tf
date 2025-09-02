##### EC2

variable "ec2_ami" {
  description = "AMI used"
  type        = string
  default     = ""
}
variable "ec2_instance_type" {
  description = "Instance type used by the EC2"
  type        = string
  default     = ""
}
variable "ec2_az" {
  description = "AZ used by the EC2"
  type        = string
  default     = "us-east-1a"
}
variable "ec2_subnet" {
  description = "Subnet used by the EC2"
  type        = string
  default     = ""
}
variable "ec2_ebs_optimized" {
  description = "Enable EBS optimization"
  type        = bool
  default     = "false"
}
variable "ec2_iam_instance_profile" {
  description = "IAM Instance profile"
  type        = string
  default     = ""
}
variable "ec2_key_name" {
  description = "Key name used for SSH"
  type        = string
  default     = ""
}
variable "ec2_monitoring" {
  description = "Detailed monitoring"
  type        = bool
  default     = "false"
}
variable "ec2_securitygroups" {
  description = "Security Groups used for the EC2s"
  type        = list(string)
}
variable "ec2_user_data" {
  description = "User Data to run when the EC2 starts"
  type        = string
  default     = ""
}
variable "ec2_instance_name" {
  description = "Name of the EC2 Instance"
  type        = string
  default     = ""
}
variable "ec2_metadata_hops" {
  description = "Number of hops to get metadata"
  type        = number
  default     = "2"
}

##### EBS

variable "ebs_volume_size" {
  description = "Size of the EBS disk"
  type        = number
  default     = "25"
}
variable "ebs_volume_type" {
  description = "Type of EBS disk"
  type        = string
  default     = "gp3"
}
variable "ebs_throughput" {
  description = "Disk Throughput"
  type        = number
  default = "125"
}
variable "ebs_iops" {
  description = "Disk IOPS"
  type        = number
  default = "3000"
}
