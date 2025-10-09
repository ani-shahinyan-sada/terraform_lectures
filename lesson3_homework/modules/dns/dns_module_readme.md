# DNS Module

## Overview
Creates a private Cloud DNS managed zone for internal hostname resolution. VMs in the VPC can resolve custom domain names instead of using IP addresses.

## Resources Created
- `google_dns_managed_zone` - Private DNS zone visible only within specified VPC

## Usage

```hcl
module "dns" {
  source = "./modules/dns"
  
  project_id        = var.project_id
  private-zone-name = "monitoring-private-zone"
  dns-name          = "monitoring.internal."
  visibility-type   = "private"
  vpc_network_id    = module.vpc.vpc_network_id
}
```

## Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `project_id` | string | yes | gcp project id where the dns managed zone will be created |
| `private-zone-name` | string | yes | resource identifier for the managed zone (not the dns domain), passed from root variable, used in gcp console and terraform state |
| `dns-name` | string | yes | actual dns domain suffix for the zone (must end with dot, e.g., 'ani.dev.com.'), passed from root variable, used as base domain for all dns records |
| `visibility-type` | string | no (default: "private") | access scope for dns zone: 'private' (only within specified vpcs) or 'public' (internet-accessible), passed from root variable |
| `vpc_network_id` | string | yes | self_link/id of the vpc network that can query this private dns zone, comes from vpc module output, required for private zones |

## Outputs

| Output | Type | Description | Used By |
|--------|------|-------------|---------|
| `managed_zone_name` | string | resource name of the managed zone, passed to dns_records module to specify which zone to add records to | DNS Records module |
| `managed_zone_dns_name` | string | full dns domain with trailing dot (e.g., 'ani.dev.com.'), passed to dns_records module to construct full record names | DNS Records module |
| `id` | string | terraform resource identifier for the dns zone (format: projects/{{project}}/managedZones/{{name}}), not currently used by other modules | Not currently used |
| `managed_zone_id` | string | gcp-assigned numeric id for the managed zone, not currently used by other modules but useful for api calls or debugging | Not currently used |
| `name_servers` | list(string) | list of authoritative name servers for this zone, empty for private zones, used for public zone delegation, not currently consumed by other modules | Not currently used |

## Configuration Details

### Private Visibility Configuration
The `private_visibility_config` block specifies which VPC networks can query this DNS zone:
```hcl
private_visibility_config {
  networks {
    network_url = var.vpc_network_id
  }
}
```

Only VMs within the specified VPC can resolve DNS records in this zone.

### DNS Zone Naming
- **Zone Name (`private-zone-name`)**: Resource identifier (e.g., "dev-rpivate-zone-ani")
- **DNS Name (`dns-name`)**: Actual domain with trailing dot (e.g., "ani.dev.com.")

The trailing dot is required by DNS standards and indicates this is a fully qualified domain name.

### Private vs Public Zones
- **Private (`visibility = "private"`)**: 
  - Only accessible within specified VPC networks
  - Ideal for internal service communication
  - Not visible on the internet
  - Requires `private_visibility_config` with VPC network

- **Public (`visibility = "public"`)**: 
  - Accessible from anywhere on the internet
  - Requires domain ownership verification
  - Uses Google's public DNS servers

## Dependencies
- **VPC Module** - requires `vpc_network_id` output to configure private zone visibility

## Notes
- This creates a single private DNS zone for all VMs
- The zone provides internal DNS resolution for the monitoring infrastructure
- VMs can use friendly hostnames instead of IP addresses to communicate
- DNS records are added via the dns_records module, not directly in this module
- For private zones, `name_servers` output will be empty since Google handles resolution internally
- The zone must be created before DNS records can be added to it