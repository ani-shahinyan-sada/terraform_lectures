variable "project_id" {
  description = "The GCP project ID where VPC resources will be created"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnets" {
  description = "Map of subnets to create. Each subnet must specify subnet_name, ip_cidr_range, and region."
  type = map(object({
    subnet_name   = string
    ip_cidr_range = string
    region        = string
  }))
}