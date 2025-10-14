variable "project_id" {
  description = "The GCP project ID where VM instances will be created"
  type        = string
}

variable "vm_instances" {
  description = "Map of VM instances to create. Each instance must specify name, zone, subnet_key, and startup_script."
  type = map(object({
    name           = string
    zone           = string
    subnet_key     = string
    startup_script = string
  }))
}

variable "network" {
  description = "The name or self_link of the VPC network to attach instances to"
  type        = string
}

variable "subnets" {
  description = "Map of subnet keys to subnet self_links. Keys must match subnet_key in vm_instances."
  type        = map(string)
}

variable "machine_type" {
  description = "The machine type for all VM instances"
  type        = string
  default     = "n1-standard-1"
}

variable "boot_disk_image" {
  description = "The boot disk image for all VM instances"
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "network_tags" {
  description = "List of network tags to apply to all VM instances"
  type        = list(string)
  default     = []
}

variable "service_account_email" {
  description = "The service account email to attach to all VM instances"
  type        = string
}

variable "service_account_scopes" {
  description = "List of scopes for the service account"
  type        = list(string)
  default     = ["cloud-platform"]
}

variable "startup_script_bucket_url" {
  description = "The base URL of the GCS bucket containing startup scripts (e.g., https://storage.cloud.google.com/bucket-name)"
  type        = string
}