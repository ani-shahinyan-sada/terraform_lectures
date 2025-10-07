variable "dns_record_name" {
  type        = string
  description = "the DNS record name for the VM"
}

variable "record_type" {
  type        = string
  description = "the type of the record to be added in dns zone"
}

variable "project_id" {
  type        = string
  description = "project where resources are configured"
}

variable "dns_zone_name" {
  type        = string
  description = "the name of the DNS managed zone"
}

variable "dns_zone_dns_name" {
  type        = string
  description = "the DNS name of the managed zone"
}

variable "vm_network_ip" {
  type        = string
  description = "the internal IP of the VM instance"
}