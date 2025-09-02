variable "s3_bucket_name" {
  description = "S3 Bucket Name"
  type        = string
  default     = ""
}

variable "s3_bucket_for_logging" {
  description = "S3 bucket used for logging"
  type        = string
  default     = ""
}

variable "s3_bucket_for_logging_path" {
  description = "Path inside the S3 Bucket used for logs"
  type        = string
  default     = ""
}