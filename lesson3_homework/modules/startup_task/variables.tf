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
  type = string
  description = "the service account has the following role on the bucket objetcs (for the vms)"
  default = "roles/storage.objectViewer"
  
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
      name  = "allow-nssh-access"
      ports = ["22"]
    }

  }
}

variable "vm_attributes" {
  type = map(object({
    name           = string
    startup_script = string
    zone           = string
    dns_name       = string
    subnet = object({
      region      = string
      subnet_name = string
      mask        = string
    })
  }))
  description = "the attributes vm's should have"
  default = {
    node-vm = {
      name           = "node-exporter-vm"
      startup_script = "node-script.sh"
      zone           = "us-central1-a"
      dns_name       = "node.monitoring"
      subnet = {
        region      = "us-central1"
        subnet_name = "sirelis1-vm"
        mask        = "10.5.0.0/24"
      }
    }
    prom-vm = {
      name           = "prometheus-vm"
      startup_script = "prom-script.sh"
      zone           = "us-central1-a"
      dns_name       = "prom.monitoring"
      subnet = {
        region      = "us-central1"
        subnet_name = "sirelis2-vm"
        mask        = "10.6.0.0/24"
      }
    }
    graf-vm = {
      name           = "grafana-vm"
      startup_script = "graf-script.sh"
      zone           = "us-central1-a"

      dns_name = "graf.monitoring"
      subnet = {
        region      = "us-central1"
        subnet_name = "sirelis3-vm"
        mask        = "10.7.0.0/24"
      }
    }
    loki-vm = {
      name           = "loki-vm"
      startup_script = "loki-script.sh"
      zone           = "us-central1-a"

      dns_name = "loki.monitoring"
      subnet = {
        region      = "us-central1"
        subnet_name = "sirelis4-vm"
        mask        = "10.8.0.0/24"
      }
    }
    promtail-vm = {
      name           = "promtail-vm"
      startup_script = "promtail-script.sh"
      zone           = "us-west1-a"

      dns_name = "promtail.monitoring"
      subnet = {
        region      = "us-west1"
        subnet_name = "sirelis5-vm"
        mask        = "10.9.0.0/24"
      }
    }
  }
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
