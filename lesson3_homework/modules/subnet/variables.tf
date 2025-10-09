variable "project_id" {
  type        = string
  description = "gcp project id where the subnet will be created, passed from root variable"
}

variable "vpc_network_self_link" {
  type        = string
  description = "full resource path of vpc network to create subnet in, comes from vpc module output, all subnets are created in the same vpc"
}

variable "subnet_name" {
  type        = string
  description = "unique name for this subnet, comes from vm_attributes map in root , each vm gets its own dedicated subnet"
}

variable "subnet_mask" {
  type        = string
  description = "cidr range for subnet's ip addresses (e.g., '10.5.0.0/24'), comes from vm_attributes map in root, each subnet has different non-overlapping range"
}

variable "subnet_region" {
  type        = string
  description = "gcp region where subnet will be created (e.g., 'us-central1'), comes from vm_attributes map in root "
}
