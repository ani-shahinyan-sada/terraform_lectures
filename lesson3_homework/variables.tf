variable "project_id" {
  type        = string
  description = "project where resources are configured"
}

variable "zone" {
  type        = string
  description = "the zone of the resources"
}

variable "machine_filter" {
  type        = string
  description = "the filter to obtain a machine type"
}

variable "image_family" {
  type        = string
  description = "the family of images to use from"
}

variable "image_repository" {
  type        = string
  description = "the repository of images to use from"
}

variable "service_account_id" {
  type        = string
  description = "the account id of the service account"
}

variable "service_account_display_name" {
  type        = string
  description = "the display name of the service account"
}

variable "vpc_network_name" {
  type        = string
  description = "the name of the vpc network"
}

variable "bucket_name" {
  type        = string
  description = "the bucket name for the startup scripts"
}

variable "bucket_location" {
  type        = string
  description = "the location where the bucket is"
}

variable "role" {
  type        = string
  description = "the service account has the following role on the bucket objects"
}

variable "protocol" {
  type        = string
  description = "the protocol used by the network"
}

variable "allowed_source_ranges" {
  type        = list(string)
  description = "IP ranges allowed to access monitoring services"
}

variable "target_tags" {
  type        = list(string)
  description = "the tags given to the firewall"
}

variable "source_tags" {
  type        = list(string)
  description = "the source tags for the vms"
}

variable "scopes" {
  type        = list(string)
  description = "scope in which the service account is active"
}

variable "private_zone_name" {
  type        = string
  description = "name of the managed zone"
}

variable "dns_name" {
  type        = string
  description = "name of the dns"
}

variable "visibility_type" {
  type        = string
  description = "whether the dns zone is private or public"
}

variable "record_type" {
  type        = string
  description = "the type of the record to be added in dns zone"
}

variable "vm_attributes" {
  type = map(object({
    vm_name         = string
    startup_script  = string
    vm_zone         = string
    dns_record_name = string
    subnet_name     = string
    subnet_mask     = string
    subnet_region   = string
    firewall_name   = string
    firewall_ports  = list(string)
  }))
  description = "the attributes for each VM in the monitoring system"
}
