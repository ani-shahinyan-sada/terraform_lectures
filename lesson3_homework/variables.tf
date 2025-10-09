variable "project_id" {
  type        = string
  description = "gcp project id where all resources will be created"
}

variable "zone" {
  type        = string
  description = "default zone used by data sources to filter machine types (not directly used by resources)"
}

variable "machine_filter" {
  type        = string
  description = "filter expression passed to google_compute_machine_types data source to select vm machine type"
}

variable "image_family" {
  type        = string
  description = "os image family name passed to google_compute_image data source (e.g., 'debian-12')"
}

variable "image_repository" {
  type        = string
  description = "gcp project containing the os image (e.g., 'debian-cloud'), used by google_compute_image data source"
}

variable "service_account_id" {
  type        = string
  description = "unique identifier for service account, combined with project_id to create full email (id@project.iam.gserviceaccount.com)"
}

variable "service_account_display_name" {
  type        = string
  description = "human-readable name shown in gcp console for the service account"
}

variable "vpc_network_name" {
  type        = string
  description = "name for the vpc network, must be unique within the project"
}

variable "bucket_name" {
  type        = string
  description = "globally unique name for storage bucket that holds vm startup scripts"
}

variable "bucket_location" {
  type        = string
  description = "multi-region or region for bucket storage (e.g., 'US', 'us-central1')"
}

variable "role" {
  type        = string
  description = "iam role granted to service account on the bucket (e.g., 'roles/storage.objectViewer' allows reading startup scripts)"
}

variable "protocol" {
  type        = string
  description = "network protocol for firewall rules (typically 'tcp' or 'udp')"
}

variable "allowed_source_ranges" {
  type        = list(string)
  description = "cidr blocks allowed to connect through firewall rules (e.g., ['0.0.0.0/0'] allows all, or specific ips)"
}

variable "target_tags" {
  type        = list(string)
  description = "network tags that firewall rules will apply to (instances must have matching tags)"
}

variable "source_tags" {
  type        = list(string)
  description = "network tags assigned to vm instances (must match firewall target_tags to receive traffic)"
}

variable "scopes" {
  type        = list(string)
  description = "oauth2 scopes defining api access level for service account on vms (e.g., 'cloud-platform' gives full access)"
}

variable "private_zone_name" {
  type        = string
  description = "identifier for the cloud dns managed zone resource (not the dns domain name)"
}

variable "dns_name" {
  type        = string
  description = "actual dns domain name for the zone, must end with a dot (e.g., 'ani.dev.com.')"
}

variable "visibility_type" {
  type        = string
  description = "whether dns zone is accessible from internet ('public') or only within vpc ('private')"
}

variable "record_type" {
  type        = string
  description = "dns record type for all vm dns entries (e.g., 'A' for ipv4 addresses)"
}

variable "vm_attributes" {
  type = map(object({
    vm_name         = string       # name of the compute instance resource
    startup_script  = string       # filename in ./scripts/ directory that will be uploaded to bucket and run on vm boot
    vm_zone         = string       # gcp zone where this specific vm will be created
    dns_record_name = string       # hostname portion of dns record (will be combined with zone dns_name)
    subnet_name     = string       # name for subnet resource dedicated to this vm
    subnet_mask     = string       # cidr range for this vm's subnet (e.g., '10.5.0.0/24')
    subnet_region   = string       # region where subnet will be created (must match or contain vm_zone)
    firewall_name   = string       # name for firewall rule allowing traffic to this vm
    firewall_ports  = list(string) # tcp/udp ports to open in firewall for this vm (e.g., ['9090'])
  }))
  description = "map of vm configurations keyed by identifier (e.g., 'node-vm'), each vm gets its own subnet, firewall, dns record"
}