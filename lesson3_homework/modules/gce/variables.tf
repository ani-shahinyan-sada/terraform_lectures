variable "project_id" {
  type        = string
  description = "project where resources are configured"
}

variable "vm_name" {
  type        = string
  description = "the name of the VM instance"
}

variable "machine_type" {
  type        = string
  description = "the machine type for the VM"
}

variable "vm_zone" {
  type        = string
  description = "the zone where the VM will be created"
}

variable "image_self_link" {
  type        = string
  description = "the self link of the image to use"
}

variable "source_tags" {
  type        = list(string)
  description = "the source tags for the vms"
}

variable "vpc_network_self_link" {
  type        = string
  description = "the self link of the VPC network"
}

variable "subnet_self_link" {
  type        = string
  description = "the self link of the subnet"
}

variable "startup_script_url" {
  type        = string
  description = "the URL to the startup script in GCS"
}

variable "service_account_email" {
  type        = string
  description = "the email of the service account"
}

variable "scopes" {
  type        = list(string)
  description = "scope in which the service account is active"
}
