variable "project_id" {
  description = "The GCP project ID where firewall rules will be created"
  type        = string
}

variable "network" {
  description = "The name or self_link of the network to attach firewall rules to"
  type        = string
}

variable "firewall_rules" {
  description = "Map of firewall rules to create. Each rule must specify a name and list of ports."
  type = map(object({
    name  = string
    ports = list(string)
  }))
}

variable "protocol" {
  description = "The IP protocol to which this rule applies (tcp, udp, icmp, esp, ah, sctp, ipip, all)"
  type        = string
  default     = "tcp"

}

variable "source_ranges" {
  description = "List of source IP CIDR ranges that this firewall rule applies to"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_tags" {
  description = "List of target tags that this firewall rule applies to"
  type        = list(string)
  default     = []
}