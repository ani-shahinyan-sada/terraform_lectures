# Subnet Module

## Overview
Creates isolated subnets within the VPC. Each VM gets its own dedicated subnet with a unique IP range, providing network-level separation between services.

## Resources Created
- `google_compute_subnetwork` - Regional subnet with specified CIDR range

## Usage

```hcl
module "subnet" {
  for_each = var.vm_attributes
  source   = "./modules/subnet"
  
  project_id            = var.project_id
  vpc_network_self_link = module.vpc.vpc_network_self_link
  subnet_name           = each.value.subnet_name
  subnet_mask           = each.value.subnet_mask
  subnet_region         = each.value.subnet_region
}
```

## Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `project_id` | string | yes | gcp project id where the subnet will be created, passed from root variable |
| `vpc_network_self_link` | string | yes | full resource path of vpc network to create subnet in, comes from vpc module output, all subnets are created in the same vpc |
| `subnet_name` | string | yes | unique name for this subnet, comes from vm_attributes map in root (e.g., 'node-subnet'), each vm gets its own dedicated subnet |
| `subnet_mask` | string | yes | cidr range for subnet's ip addresses (e.g., '10.5.0.0/24'), comes from vm_attributes map in root, each subnet has different non-overlapping range |
| `subnet_region` | string | yes | gcp region where subnet will be created (e.g., 'us-central1'), comes from vm_attributes map in root, must contain the vm's zone (e.g., vm_zone 'us-central1-a' must be in region 'us-central1') |

## Outputs

| Output | Type | Description | Used By |
|--------|------|-------------|---------|
| `subnet_self_link` | string | full resource path of the created subnet (format: projects/{{project}}/regions/{{region}}/subnetworks/{{name}}), passed to gce module via for_each to attach vm's network interface to its dedicated subnet | GCE module (matched by for_each key) |

## Configuration Details

### Subnet Isolation
Each VM receives its own subnet with a unique CIDR range. Example configuration:
- node-exporter-vm: 10.5.0.0/24
- prometheus-vm: 10.6.0.0/24
- grafana-vm: 10.7.0.0/24
- loki-vm: 10.8.0.0/24
- promtail-vm: 10.9.0.0/24

### Region and Zone Relationship
The subnet region must contain the VM's zone. For example:
- If `vm_zone = "us-central1-a"`, then `subnet_region` must be `"us-central1"`
- If `vm_zone = "us-west2-a"`, then `subnet_region` must be `"us-west2"`

## Dependencies
- **VPC Module** - requires `vpc_network_self_link` output

## Notes
- Created via `for_each` loop - one subnet per VM
- Each subnet has a non-overlapping CIDR range to avoid IP conflicts
- Provides network-level isolation between different monitoring services
- All subnets are in the same VPC but have different IP ranges and can be in different regions