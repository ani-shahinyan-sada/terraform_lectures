# VPC Module

## Overview
Creates a custom VPC network that serves as the foundation for all other resources. Uses custom subnet mode to allow manual subnet creation with specific IP ranges.

## Resources Created
- `google_compute_network` - VPC network with manual subnet creation

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"
  
  project_id       = "my-project-123"
  vpc_network_name = "monitoring-vpc"
}
```

## Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `project_id` | string | yes | gcp project id where the vpc network will be created, passed from root variable |
| `vpc_network_name` | string | yes | unique name for the vpc network (e.g., 'im-dev-vpc-for-modules'), passed from root variable, must be unique within the project |

## Outputs

| Output | Type | Description | Used By |
|--------|------|-------------|---------|
| `vpc_network_self_link` | string | full resource path of vpc network (format: projects/{{project}}/global/networks/{{name}}), passed to subnet, firewall, and gce modules to attach resources to this vpc | Subnet, Firewall, GCE modules |
| `vpc_network_id` | string | terraform resource identifier for vpc network, passed to dns module to configure private dns zone visibility for this vpc, allows vms in this vpc to resolve private dns names | DNS module |

## Configuration Details

### auto_create_subnetworks
Set to `false` to enable custom subnet mode. This gives you full control over subnet creation, allowing you to specify exact CIDR ranges and regions for each subnet.

## Dependencies
None - this module should be created first as it's a foundation for other modules.

## Notes
- This is the first module that should be created in your infrastructure
- All resources in this infrastructure share this single VPC
- Custom mode networking allows precise control over IP address allocation
- The VPC provides the network isolation boundary for your entire monitoring infrastructure