variable "project_id" {
  type        = string
  description = "project where resources are configured"
  default     = "elevated-column-473707-k5"
}

variable "allowed_source_ranges" {
  type        = list(string)
  description = "IP ranges allowed to access monitoring services"
  default     = ["0.0.0.0/0"]
}

variable "role" {
  type        = string
  description = "the service account has the following role on the bucket objetcs (for the vms)"
  default     = "roles/storage.objectViewer"

}

variable "protocol" {
  description = "the protocol used by the network"
  type        = string
  default     = "tcp"
}

variable "source_tags" {
  description = "the source tags for the vms"
  type        = list(string)
  default     = ["foo", "bar"]

}

variable "target_tags" {
  description = "the tags given to the firewall"
  type        = list(string)
  default     = ["foo", "bar"]
}

variable "bucket_name" {
  description = "the bucket name for the bucket of the startup_scripts"
  type        = string
  default     = "startupscripts"

}

variable "bucket_location" {
  description = "the location where the bucket is"
  type        = string
  default     = "US"
}

variable "firewall_name" {
  type        = string
  description = "the name of the firewall rule"
}

variable "firewall_ports" {
  type        = list(string)
  description = "the ports to allow in the firewall rule"
}

variable "vm_name" {
  type        = string
  description = "the name of the VM instance"
}

variable "startup_script" {
  type        = string
  description = "the startup script filename for the VM"
}

variable "vm_zone" {
  type        = string
  description = "the zone where the VM will be created"
}

variable "dns_record_name" {
  type        = string
  description = "the DNS record name for the VM"
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

variable "record_type" {
  description = "the type of the record to be added in dns zone"
  type        = string
  default     = "A"
}

variable "private-zone-name" {
  description = "name of the managed zone"
  type        = string
  default     = "private-zone-ani-com"
}

variable "dns-name" {
  description = "name of the dns"
  type        = string
  default     = "ani.com."
}

variable "visibility-type" {
  description = "whether the dns zone is private or public"
  type        = string
  default     = "private"
}

variable "service_acc_id" {
  description = "the id of the service account"
  type        = string
  default     = "sireliserviceaccount@elevated-column-473707-k5.iam.gserviceaccount.com"
}


variable "region" {
  description = "the region of the resources"
  type        = string
  default     = "us-central1"
}


variable "zone" {
  type        = string
  description = "the zone of the resources"
  default     = "us-central1-a"
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



variable "metadata_startup_script" {
  type        = string
  description = "the metadata of vms"
  default     = "echo hi > /test.txt"
}
