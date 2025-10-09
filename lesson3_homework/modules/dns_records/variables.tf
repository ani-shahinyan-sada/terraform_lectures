variable "dns_record_name" {
  type        = string
  description = "hostname portion without domain ( 'node.monitoring'), comes from vm_attributes map in root module, combined with dns_zone_dns_name to form full domain"
}

variable "record_type" {
  type        = string
  description = "dns record type ( 'A' for ipv4 addresses), passed from root variable, used for  vm records"
}

variable "project_id" {
  type        = string
  description = "gcp project id where the dns record will be created, passed from root variable"
}

variable "dns_zone_name" {
  type        = string
  description = "resource identifier of the managed zone to add this record to, comes from dns module output (managed_zone_name), not the dns domain"
}

variable "dns_zone_dns_name" {
  type        = string
  description = "actual dns domain suffix with trailing dot (e.g., 'ani.com.'), comes from dns module output (managed_zone_dns_name)"
}

variable "vm_network_ip" {
  type        = string
  description = "internal ip address assigned to the vm instance, comes from gce module output (instance_network_ip). this is what the dns record resolves to"
}
