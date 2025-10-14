variable "project_id" {
  description = "The GCP project ID where DNS resources will be created"
  type        = string
}

variable "zone_name" {
  description = "The name of the managed DNS zone"
  type        = string
}

variable "dns_name" {
  description = "The DNS name of the managed zone (must end with a period)"
  type        = string

}

variable "visibility" {
  description = "The visibility of the DNS zone (private or public)"
  type        = string
  default     = "private"
}

variable "network" {
  description = "The self_link of the VPC network for private DNS zone"
  type        = string
}

variable "vm_instances" {
  description = "Map of VM instances"
  type        = map(any)
}

variable "external_ips" {
  description = "Map of external IPs for VM instances"
  type        = map(string)
}

variable "record_type" {
  description = "The DNS record type"
  type        = string
  default     = "A"
}
