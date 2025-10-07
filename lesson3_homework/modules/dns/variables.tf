variable "project_id" {
  type        = string
  description = "project where resources are configured"
}

variable "private-zone-name" {
  type        = string
  description = "name of the managed zone"
}

variable "dns-name" {
  type        = string
  description = "name of the dns"
}

variable "visibility-type" {
  type        = string
  description = "whether the dns zone is private or public"
}

variable "vpc_network_id" {
  type        = string
  description = "the ID of the VPC network"
}