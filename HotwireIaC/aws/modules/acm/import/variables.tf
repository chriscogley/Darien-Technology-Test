variable "acm_private_key" {
  description = "Private Key used by the SSL Certificate"
  type        = string
  default     = ""
}
variable "acm_certificate_body" {
  description = "Body used by the SSL Certificate"
  type        = string
  default     = ""
}
variable "acm_certificate_chain" {
  description = "Chain used by the SSL Certificate"
  type        = string
  default     = ""
}