variable "rds_name" {
  type = string
}

variable "rds_sns_topic" {
  type = string
}

variable "rds_source_ids" {
  type = set(string)
}

variable "rds_source_type" {
  type = string
}

variable "rds_event_categories" {
  type = set(string)
}

variable "rds_enabled" {
  type = bool
}