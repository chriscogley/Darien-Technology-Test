variable "cache_cluster_id" {
  description = "Cluster name"
  type = string
  default = ""
}
variable "cache_engine" {
  description = "Engine used by Elasticache. Redis/Memcached"
  type = string
  default = "redis"
}
variable "cache_node_type" {
  description = "Instance type used by Elasticache"
  type = string
  default = ""
}
variable "cache_num_cache_nodes" {
  description = "Number of nodes used by Elasticache"
  type = number
  default = 1
}
variable "cache_parameter_group_name" {
  description = "The name of the parameter group to associate with this cache cluster."
  type = string
  default = ""
}
variable "cache_apply_immediately" {
  description = "Whether any database modifications are applied immediately, or during the next maintenance window."
  type = bool
  default = "false"
}
variable "cache_auto_minor_version_upgrade" {
  description = "Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. "
  type = string
  default = "true"
}
variable "cache_availability_zone" {
  description = "Availability Zone for the cache cluster. "
  type = string
  default = ""
}
variable "cache_engine_version" {
  description = "Version number of the cache engine to be used."
  type = string
  default = ""
}
variable "cache_final_snapshot_identifier" {
  description = "Name of your final cluster snapshot."
  type = string
  default = ""
}
variable "cache_maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC) "
  type = string
  default = ""
}
variable "cache_network_type" {
  description = "The IP versions for cache cluster connections. Valid values are ipv4, ipv6 or dual_stack "
  type = string
  default = ""
}
variable "cache_notification_topic_arn" {
  type = string
  default = null
}
variable "cache_port" {
  type = number
}
variable "cache_replication_group_id" {
  type = string
  default = null
}
variable "cache_security_group_ids" {
  type = string
  default = ""
}
variable "cache_snapshot_window" {
  type = string
}
variable "cache_subnet_group_name" {
  type = string
}

##### log_delivery_configuration
variable "cache_log_destination" {
  type = string
  default = ""
}
variable "cache_log_destination_type" {
  type = string
  default = ""
}
variable "cache_log_format" {
  type = string
  default = ""
}
variable "cache_log_type" {
  type = string
  default = ""
}