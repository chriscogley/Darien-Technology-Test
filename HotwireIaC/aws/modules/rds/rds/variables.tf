variable "rds_identifier" {
  description = "Name of the RDS"
  type = string
  default = ""
}
variable "rds_db_name" {
  description = "Name of the DB inside of the RDS"
  type = string
  default = ""
}
variable "rds_instance_class" {
  description = "Instance type for the RDS"
  type = string
  default = ""
}
variable "rds_engine" {
  description = "Engine used for RDS. MySQL, MariaDB, PostgreSQL"
  type = string
  default = ""
}
variable "rds_engine_ver" {
  description = "Version of the engine"
  type = string
  default = ""
}
variable "rds_multi_az" {
  description = "Enable Multi AZ"
  type = string
  default = ""
}
variable "rds_maintenance_window" {
  description = "The window to perform maintenance in"
  type = string
  default = ""
}
variable "rds_timezone" {
  description = "Time zone of the DB instance"
  type = string
  default = null
}
variable "rds_custom_iam_profile" {
  description = "The instance profile associated with the underlying Amazon EC2 instance of an RDS Custom DB instance."
  type = string
  default = null
}
variable "rds_allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed."
  type = bool
  default = false
}
variable "rds_allocated_storage" {
  description = "The allocated storage in gibibytes."
  type = number
}
variable "rds_apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  type = bool
  default = false
}
variable "rds_max_allocated_storage" {
  description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
  type = number
}
variable "rds_storage_type" {
  description = "Type of storage. gp2, gp3, io1"
  type = string
  default = "gp3"
}
variable "rds_storage_throughput" {
  description = "The storage throughput value for the DB instance"
  type = number
}
variable "rds_iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of io1"
  type = number
}
variable "rds_username" {
  description = "Username for the master DB user."
  type = string
  default = ""
}
variable "rds_port" {
  description = "The port on which the DB accepts connections"
  type = number
  default = "39210"
}
variable "rds_az" {
  description = "The availability zone of the instance."
  type = string
  default = ""
}
variable "rds_subnet_group" {
  description = "Name of DB subnet group."
  type = string
  default = ""
}
variable "rds_sg_ids" {
  description = "List of VPC security groups to associate."
  type = string
  default = ""
}
variable "rds_cw_logs_exports" {
  description = "Set of log types to enable for exporting to CloudWatch logs."
  type = string
  default = ""
}
variable "rds_option_group" {
  description = "Name of the DB option group to associate."
  type = string
  default = ""
}
variable "rds_parameter_group" {
  description = "Name of the DB parameter group to associate."
  type = string
  default = ""
}
variable "rds_backup_retention" {
  description = "The days to retain backups for."
  type = number
  default = "7"
}
variable "rds_delete_auto_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted. "
  type = bool
  default = false
}
variable "rds_final_snapshot" {
  description = "The name of your final DB snapshot when this DB instance is deleted."
  type = string
  default = ""
}
variable "rds_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance"
  type = string
  default = ""
}
variable "rds_monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  type = string
  default = ""
}
variable "rds_performance_insights" {
  description = "Specifies whether Performance Insights are enabled. Defaults to false."
  type = bool
  default = true
}
variable "rds_performance_insights_retention" {
  description = "Amount of time in days to retain Performance Insights data."
  type = number
  default = "7"
}

variable "rds_ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance"
  type = string
  default = "rds-ca-rsa4096-g1"
}