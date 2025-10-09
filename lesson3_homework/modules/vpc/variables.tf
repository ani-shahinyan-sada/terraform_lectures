variable "project_id" {
  type        = string
  description = "gcp project id where the vpc network will be created, passed from root variable"
}

variable "vpc_network_name" {
  type        = string
  description = "unique name for the vpc network , passed from root variable"
}
