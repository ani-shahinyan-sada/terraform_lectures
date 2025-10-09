variable "project_id" {
  type        = string
  description = "gcp project id where the firewall rule will be created, passed from root variable"
  default = ""
}

variable "firewall_name" {
  type        = string
  description = "unique name for this firewall rule, comes from vm_attributes map in root (e.g., 'allow-node-exporter'), must be unique per project"
  default = ""
}

variable "vpc_network_self_link" {
  type        = string
  description = "full resource path of the vpc network to attach this rule to, comes from vpc module output"
  default = ""
}

variable "protocol" {
  type        = string
  description = "network protocol to allow through firewall , passed from root variable, same for all firewall rules"
  default = "tcp"
}

variable "firewall_ports" {
  type        = list(string)
  description = "list of port numbers to open for this specific vm (e.g., ['9100'] for node exporter), comes from vm_attributes map in root, each vm has different ports"
  default = [ ]
}

variable "allowed_source_ranges" {
  type        = list(string)
  description = "cidr blocks allowed to connect to these ports, passed from root variable, same for all rules"
  default = [  ]
}

variable "target_tags" {
  type        = list(string)
  description = "network tags that this firewall rule applies to, passed from root variable, vms must have matching source_tags to receive traffic through this rule"
  default = [ "foo" , "bar" ]
}
