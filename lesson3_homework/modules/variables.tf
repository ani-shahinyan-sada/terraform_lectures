variable "project_id" {
  type        = string
  description = "GCP project ID"
  default     = "elevated-column-473707-k5"
}

variable "region" {
  description = "Default region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Default zone for resources"
  default     = "us-central1-a"
}

variable "vpc_network_name" {
  type        = string
  description = "Name of the VPC network"
  default     = "im-sireli-vpc"
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    subnet_name   = string
    region        = string
    ip_cidr_range = string
  }))
  default = {
    node-subnet = {
      subnet_name   = "node-subnet"
      region        = "us-central1"
      ip_cidr_range = "10.5.0.0/24"
    }
    prom-subnet = {
      subnet_name   = "prom-subnet"
      region        = "us-central1"
      ip_cidr_range = "10.6.0.0/24"
    }
    graf-subnet = {
      subnet_name   = "graf-subnet"
      region        = "us-central1"
      ip_cidr_range = "10.7.0.0/24"
    }
    loki-subnet = {
      subnet_name   = "loki-subnet"
      region        = "us-central1"
      ip_cidr_range = "10.8.0.0/24"
    }
    promtail-subnet = {
      subnet_name   = "promtail-subnet"
      region        = "us-east1"
      ip_cidr_range = "10.9.0.0/24"
    }
  }
}

variable "bucket_name" {
  description = "Bucket name for startup scripts"
  type        = string
  default     = "startupscripts"
}

variable "bucket_location" {
  description = "Location for the GCS bucket"
  type        = string
  default     = "US"
}

variable "force_destroy" {
  description = "Allow bucket deletion with objects"
  type        = bool
  default     = false
}

variable "bucket_objects" {
  description = "Map of objects to upload to bucket"
  type = map(object({
    name   = string
    source = string
  }))
  default = {
    node-script = {
      name   = "node-exporter-vm"
      source = "../scripts/node-script.sh"
    }
    prom-script = {
      name   = "prometheus-vm"
      source = "../scripts/prom-script.sh"
    }
    graf-script = {
      name   = "grafana-vm"
      source = "../scripts/graf-script.sh"
    }
    loki-script = {
      name   = "loki-vm"
      source = "../scripts/loki-script.sh"
    }
    promtail-script = {
      name   = "promtail-vm"
      source = "../scripts/promtail-script.sh"
    }
  }
}

variable "account_id" {
  type        = string
  description = "Service account ID"
  default     = "sireli-service-account"
}

variable "display_name" {
  type        = string
  description = "Display name for the service account"
  default     = "sireli service account jan"
}

variable "role" {
  type        = string
  description = "IAM role for service account on bucket"
  default     = "roles/storage.objectViewer"
}

variable "scopes" {
  type        = list(string)
  description = "Scopes for service account"
  default     = ["cloud-platform"]
}

# Firewall Variables
variable "protocol" {
  description = "Protocol for firewall rules"
  type        = string
  default     = "tcp"
}

variable "allowed_source_ranges" {
  type        = list(string)
  description = "IP ranges allowed to access services"
  default     = ["0.0.0.0/0"]
}

variable "source_tags" {
  description = "Network tags for VMs"
  type        = list(string)
  default     = ["foo", "bar"]
}

variable "target_tags" {
  description = "Target tags for firewall rules"
  type        = list(string)
  default     = ["foo", "bar"]
}

variable "firewall_rules" {
  type = map(object({
    name  = string
    ports = list(string)
  }))
  description = "Firewall rules for monitoring services"
  default = {
    grafana = {
      name  = "allow-grafana"
      ports = ["3000"]
    }
    prometheus = {
      name  = "allow-prometheus"
      ports = ["9090"]
    }
    node-exporter = {
      name  = "allow-node-exporter"
      ports = ["9100"]
    }
    loki = {
      name  = "allow-loki"
      ports = ["3100"]
    }
    promtail = {
      name  = "allow-promtail"
      ports = ["9080"]
    }
    ssh-access = {
      name  = "allow-ssh-access"
      ports = ["22"]
    }
  }
}


variable "machine_type" {
  type        = string
  description = "Machine type for VM instances"
  default     = "n1-standard-1"
}

variable "boot_disk_image" {
  type        = string
  description = "Boot disk image for VMs"
  default     = "debian-cloud/debian-12"
}

variable "vm_instances" {
  description = "Map of VM instances to create"
  type = map(object({
    name           = string
    zone           = string
    subnet_key     = string
    startup_script = string
  }))
  default = {
    node-vm = {
      name           = "node-exporter-vm"
      zone           = "us-central1-a"
      subnet_key     = "node-subnet"
      startup_script = "node-exporter-vm"
    }
    prom-vm = {
      name           = "prometheus-vm"
      zone           = "us-central1-a"
      subnet_key     = "prom-subnet"
      startup_script = "prometheus-vm"
    }
    graf-vm = {
      name           = "grafana-vm"
      zone           = "us-central1-a"
      subnet_key     = "graf-subnet"
      startup_script = "grafana-vm"
    }
    loki-vm = {
      name           = "loki-vm"
      zone           = "us-central1-a"
      subnet_key     = "loki-subnet"
      startup_script = "loki-vm"
    }
    promtail-vm = {
      name           = "promtail-vm"
      zone           = "us-east1-b"
      subnet_key     = "promtail-subnet"
      startup_script = "promtail-vm"
    }
  }
}

# DNS Variables
variable "private_zone_name" {
  description = "Name of the private DNS zone"
  type        = string
  default     = "private-zone-ani-com"
}

variable "dns_name" {
  description = "DNS name for the zone"
  type        = string
  default     = "ani.com."
}

variable "visibility_type" {
  description = "Visibility type for DNS zone"
  type        = string
  default     = "private"
}

variable "record_type" {
  description = "DNS record type"
  type        = string
  default     = "A"
}
