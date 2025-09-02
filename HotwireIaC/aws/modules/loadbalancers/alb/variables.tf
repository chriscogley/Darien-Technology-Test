variable "alb_name" {
  description = "The name of the LB."
  type        = string
  default     = ""
}

variable "alb_internal" {
  description = "If true, the LB will be internal."
  type        = bool
  default     = false
}

variable "alb_type" {
  description = "The type of load balancer to create."
  type        = string
  default     = "application"
}

variable "alb_sg" {
  description = "A list of security group IDs to assign to the LB."
  type        = string
  default     = ""
}

variable "alb_subnets" {
  description = "A list of subnet IDs to attach to the LB."
  type        = string
  default     = ""
}

variable "alb_desync_mitigation" {
  description = "Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync."
  type        = string
  default     = "defensive"
}