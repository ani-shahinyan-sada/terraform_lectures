variable "project_id" {
  type        = string
  description = "project where resources are configured"
}

variable "firewall_name" {
  type        = string
  description = "the name of the firewall rule"
}

variable "vpc_network_self_link" {
  type        = string
  description = "the self link of the VPC network"
}

variable "protocol" {
  type        = string
  description = "the protocol used by the network"
}

variable "firewall_ports" {
  type        = list(string)
  description = "the ports to allow in the firewall rule"
}

variable "allowed_source_ranges" {
  type        = list(string)
  description = "IP ranges allowed to access monitoring services"
}

variable "target_tags" {
  type        = list(string)
  description = "the tags given to the firewall"
}
