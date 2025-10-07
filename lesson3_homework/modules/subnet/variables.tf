variable "project_id" {
  type        = string
  description = "project where resources are configured"
}

variable "vpc_network_self_link" {
  type        = string
  description = "the self link of the VPC network"
}

variable "subnet_name" {
  type        = string
  description = "the name of the subnet"
}

variable "subnet_mask" {
  type        = string
  description = "the CIDR mask for the subnet"
}

variable "subnet_region" {
  type        = string
  description = "the region for the subnet"
}
