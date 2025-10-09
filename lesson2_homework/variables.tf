variable "project_id" {
  type        = string
  description = "project where resources are configured"
  default     = "elevated-column-473707-k5"
}


variable "node_vm_name" {
  type        = string
  description = "the name of the node exporter vm"
  default     = "node-exporter"
}

variable "prom_vm_name" {
  type        = string
  description = "the name of the prometheus vm"
  default     = "prometheus"
}

variable "region" {
  type        = string
  description = "the region of the resources"
  default     = "us-central1"
}


variable "zone" {
  type        = string
  description = "the zone of the resources"
  default     = "us-central1-a"
}

variable "tags" {
  type        = list(any)
  description = "the tags of the virtual machines"
  default     = ["foo", "bar"]
}

variable "machine_filter" {
  type        = string
  description = "the filter to obtain a machine type"
  default     = "name = \"n1-standard-1\""
}

variable "image_family" {
  type        = string
  description = "the family of images to use from"
  default     = "debian-12"
}

variable "image_repository" {
  type        = string
  description = "the repository of images to use from"
  default     = "debian-cloud"
}

variable "metadata" {
  type        = map(string)
  description = "the metadata attached to the vms"
  default     = { foo = "bar" }
}

variable "labels_1" {
  type        = map(string)
  description = "the labels of the first boot disk"
  default     = { sirelis = "mek" }
}

variable "labels_2" {
  type        = map(string)
  description = "the labels of the second boot disk"
  default     = { sirelis = "erku" }
}

variable "account_id" {
  type        = string
  description = "the account id of the service account"
  default     = "sireli_service_account"
}

variable "display_name" {
  type        = string
  description = "the display name of the service account"
  default     = "sireli service account jan"
}

variable "scopes" {
  type        = list(string)
  description = "scope in which the service account is active"
  default     = ["cloud-platform"]
}

variable "vpc_network_name" {
  type        = string
  description = "the name of the vpc network"
  default     = "im-sireli-vpc"
}

variable "subnetwork_1_name" {
  type        = string
  description = "the name of the 1st sub network"
  default     = "sirelis1"
}

variable "subnetwork_2_name" {
  type        = string
  description = "the name of the 2nd sub network"
  default     = "sirelis2"
}

variable "subnetwork_3_name" {
  type        = string
  description = "the name of the 3rd sub network"
  default     = "sirelis3"
}

variable "subnetwork_1_mask" {
  type        = string
  description = "the mask of the 1st sub network"
  default     = "10.2.0.0/24"
}

variable "subnetwork_2_mask" {
  type        = string
  description = "the mask of the 2nd sub network"
  default     = "10.3.0.0/24"
}

variable "subnetwork_3_mask" {
  type        = string
  description = "the mask of the 3rd sub network"
  default     = "10.4.0.0/24"
}

variable "metadata_startup_script" {
  type        = string
  description = "the metadata of vms"
  default     = "echo hi > /test.txt"
}
