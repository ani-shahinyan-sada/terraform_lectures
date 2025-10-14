variable "migs" {
  type = map(object({
    name               = string
    hostname           = string
    name_prefix        = string
    subnet_location         = string
    min_replicas       = number
    max_replicas       = number
    path_name = string
  }))
  default = {
    mig1 = {
      name         = "mig1"
      hostname     = "mig-simple1"
      name_prefix  = "first"
      subnet_location   = "us-west1/subnet-01"
      min_replicas = 2
      max_replicas = 2
      path_name = "mig1"
    }
    mig2 = {
      name         = "mig2"
      hostname     = "mig-simple2"
      name_prefix  = "second"
      subnet_location   = "us-west1/subnet-02"
      min_replicas = 1
      max_replicas = 1
      path_name = "mig2"
    }
  }
}

# variable "subnet_locals1" {
#   default = "us-west1/subnet-01"
#   description = "the key of the subnet1"
#   type = string
# }

# variable "subnet_locals2" {
#   default = "us-west1/subnet-02"
#   description = "the key of the subnet2"
#   type = string
# }

variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "network_name" {
  description = "The name of the network being created"
  type        = string
}

variable "shared_vpc_host" {
  type        = bool
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
  default     = false
}

variable "hostname1" {
  type        = string
  description = "the prefix that the vm's in the instance group will get"
  default     = "mig-simple1"
}

variable "hostname2" {
  type        = string
  description = "the prefix that the vm's in the instance group will get"
  default     = "mig-simple2"
}

variable "http_protocol" {
  type        = string
  description = "the protocol names for the instances"
  default     = "http"
}

variable "httpport" {
  type        = number
  description = "the port which are opened for the instances"
  default     = 80
}

variable "max_replicas1" {
  type        = number
  description = "the maximum number of vm's that can be made from the sepcified instance_template1"
  default     = null
}


variable "min_replicas1" {
  type        = number
  description = "the minimum number of vm's that can be made from the sepcified instance_template1"
  default     = null
}

variable "max_replicas2" {
  type        = number
  description = "the maximum number of vm's that can be made from the sepcified instance_template1"
  default     = null
}


variable "min_replicas2" {
  type        = number
  description = "the minimum number of vm's that can be made from the sepcified instance_template1"
  default     = null
}

#firewall variables
variable "fw_rules" {
  type = map(object({
    name          = string
    source_ranges = list(string)
    target_tags   = list(string)
    ports         = list(number)
  }))
  description = "map of firewall rules to create"
  default = {
    http = {
      name          = "allow-http"
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["http-server"]
      ports         = [80]
    }
    health_check = {
      name          = "allow-health-check"
      source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
      target_tags   = ["http-server"]
      ports         = [80]
    }
    ssh = {
      name          = "allow-ssh"
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["ssh"]
      ports         = [22]
    }
  }
}


variable "service_acc_id" {
}

variable "display_name" {
}


variable "bucket_name" {
  description = "The name of the storage bucket (must be globally unique)"
  type        = string
}

variable "location" {
  description = "The location of the bucket (US, EU, ASIA, or specific region)"
  type        = string
  default     = "US"
}

variable "force_destroy" {
  description = "When deleting the bucket, delete all objects in the bucket first"
  type        = bool
  default     = false
}

variable "mig_bucket_objects" {
  description = "Map of objects to upload to the bucket. Each object must specify name and source file path."
  type = map(object({
    name   = string
    source = string
  }))
  default = {}
}

variable "app_bucket_name" {
  description = "The name of the app storage bucket (must be globally unique)"
  type        = string
  default     = null
}

variable "app_bucket_objects" {
  description = "Map of app objects to upload to the bucket. Each object must specify name and source file path."
  type = map(object({
    name   = string
    source = string
  }))
  default = {}
}



variable "http_rule_name" {
  type        = string
  description = "name of the firewall rule"
  default     = ""
}

variable "health_check_rule_name" {
  type        = string
  description = "name of the firewall rule"
  default     = ""
}

variable "ssh_rule_name" {
  type        = string
  description = "name of the firewall rule"
  default     = ""
}

variable "firewall_direction" {
  type        = string
  description = "flow of the traffic through the firewall (ingress or egress)"
  default     = ""
}

variable "http_source_ranges" {
  type        = list(string)
  description = "list of source IP ranges that are allowed to access http"
  default     = []
}

variable "health_check_source_ranges" {
  type        = list(string)
  description = "list of source IP ranges for health check probes"
  default     = []
}

variable "ssh_source_ranges" {
  type        = list(string)
  description = "list of source IP ranges that are allowed to ssh"
  default     = []
}

variable "http_target_tags" {
  type        = list(string)
  description = "list of target tags for http firewall rule"
  default     = []
}

variable "health_check_target_tags" {
  type        = list(string)
  description = "list of target tags for health check firewall rule"
  default     = []
}

variable "ssh_target_tags" {
  type        = list(string)
  description = "list of target tags for ssh firewall rule"
  default     = []
}

variable "protocol" {
  type        = string
  description = "protocol for http traffic"
  default     = "tcp"
}

variable "ssh_protocol_name" {
  type        = string
  description = "protocol for ssh traffic"
  default     = "tcp"
}

variable "metadata_config" {
  type        = string
  description = "what kind of metadata to include in the logs"
  default     = "INCLUDE_ALL_METADATA"
}

variable "ssh_port" {
  type        = number
  description = "port number for ssh connections"
  default     = 22
}

variable "firewall_priority" {
  type        = number
  description = "priority for firewall rules, lower numbers have higher priority"
  default     = 1000
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
}

variable "tags" {
  type    = list(string)
  default = ["foo", "bar"]

}
variable "internal_ipv6_range" {
  type        = string
  default     = null
  description = "When enabling IPv6 ULA, optionally, specify a /48 from fd20::/20 (default null)"
}

variable "network_firewall_policy_enforcement_order" {
  type        = string
  default     = null
  description = "Set the order that Firewall Rules and Firewall Policies are evaluated. Valid values are `BEFORE_CLASSIC_FIREWALL` and `AFTER_CLASSIC_FIREWALL`. (default null or equivalent to `AFTER_CLASSIC_FIREWALL`)"
}


variable "bgp_always_compare_med" {
  type        = bool
  description = "If set to true, the Cloud Router will use MED values from the peer even if the AS paths differ. Default is false."
  default     = false
}

variable "bgp_best_path_selection_mode" {
  type        = string
  description = "Specifies the BGP best path selection mode. Valid values are `STANDARD` or `LEGACY`. Default is `LEGACY`."
  default     = "LEGACY"
}

variable "bgp_inter_region_cost" {
  type        = string
  description = "Specifies the BGP inter-region cost mode. Valid values are `DEFAULT` or `ADD_COST_TO_MED`."
  default     = null
}

variable "machine_type" {
  default = "e2-micro"

}

variable "region" {
  default = "us-west1"

}

variable "source_image" {
  default = "ubuntu-2404-lts"

}

variable "source_image_family" {
  default = "ubuntu-2404-lts-amd64"
}

variable "source_image_project" {
  default = "ubuntu-os-cloud"
}

# subnet variables
variable "subnets" {
  type = list(object({
    subnet_name   = string
    subnet_ip     = string
    subnet_region = string
  }))
  description = "list of subnets to create"
  default = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = "us-west1"
    }
  ]
}

# instance template variables
variable "startup_script_path" {
  type        = string
  description = "path to the startup script file"
  default     = "./nginx.sh"
}

variable "instance_template1_name_prefix" {
  type        = string
  description = "name prefix for instance template 1"
  default     = "first"
}

variable "instance_template2_name_prefix" {
  type        = string
  description = "name prefix for instance template 2"
  default     = "second"
}

variable "create_service_account" {
  type        = bool
  description = "whether to create a service account for instances"
  default     = true
}

# load balancer variables
variable "lb_name" {
  type        = string
  description = "name of the load balancer"
  default     = "gce-lb-https"
}

variable "lb_timeout_sec" {
  type        = number
  description = "backend timeout in seconds"
  default     = 10
}

variable "lb_enable_cdn" {
  type        = bool
  description = "enable cloud CDN for backend"
  default     = false
}

variable "lb_health_check_path" {
  type        = string
  description = "health check request path"
  default     = "/"
}

variable "lb_health_check_port" {
  type        = number
  description = "health check port"
  default     = 80
}

variable "lb_log_sample_rate" {
  type        = number
  description = "log sampling rate (0.0 to 1.0)"
  default     = 1.0
}

variable "lb_enable_iap" {
  type        = bool
  description = "enable identity-aware proxy"
  default     = false
}

variable "external_ip_name" {
  type        = string
  description = "name for the external IP address"
  default     = "external-ip-first"
}

# Cloud Build variables
variable "github_owner" {
  type        = string
  description = "GitHub repository owner/organization"
  default     = null
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name"
  default     = null
}

variable "github_connection_name" {
  type        = string
  description = "Name of the GitHub connection created in Cloud Build"
  default     = null
}

variable "cloudbuild_service_account" {
  type        = string
  description = "Service account email for Cloud Build"
  default     = null
}
