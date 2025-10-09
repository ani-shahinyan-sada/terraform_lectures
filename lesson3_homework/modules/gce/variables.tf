variable "project_id" {
  type        = string
  description = "gcp project id where the vm instance will be created, passed from root variable"
  default     = ""
}

variable "vm_name" {
  type        = string
  description = "unique name for this compute instance, comes from vm_attributes map in root (e.g., 'node-exporter-vm')"
  default     = ""
}

variable "machine_type" {
  type        = string
  description = "vm hardware specification (cpu/memory), comes from data source google_compute_machine_types in root using machine_filter (e.g., 'n1-standard-1')"
  default     = "n1-standard-1"
}

variable "vm_zone" {
  type        = string
  description = "gcp zone where this vm will be created, comes from vm_attributes map in root, must be within subnet's region"
  default     = ""
}

variable "image_self_link" {
  type        = string
  description = "full resource path to os boot disk image, comes from data source google_compute_image in root using image_family and image_repository"
  default     = ""
}

variable "source_tags" {
  type        = list(string)
  description = "network tags assigned to this vm instance (e.g., ['foo', 'bar']), passed from root variable, must match firewall target_tags to receive allowed traffic"
  default     = ["foo", "bar"]
}

variable "vpc_network_self_link" {
  type        = string
  description = "full resource path of vpc network for vm's network interface, comes from vpc module output, all vms share the same vpc"
  default     = ""
}

variable "subnet_self_link" {
  type        = string
  description = "full resource path of subnet for vm's network interface, comes from corresponding subnet module output via for_each, each vm gets its own dedicated subnet"
  default     = ""
}

variable "startup_script_url" {
  type        = string
  description = "gcs url to startup script that runs when vm boots, comes from object module output (script_url) via for_each, each vm runs different script"
  default     = ""
}

variable "service_account_email" {
  type        = string
  description = "email of service account attached to vm for authentication, constructed in root as 'service_account_id@project_id.iam.gserviceaccount.com', allows vm to access gcs bucket"
  default     = ""
}

variable "scopes" {
  type        = list(string)
  description = "oauth2 api access scopes for service account on this vm (e.g., ['cloud-platform'] for full gcp api access), passed from root variable, determines what apis vm can call"
  default     = ["cloud-platform"]
}
