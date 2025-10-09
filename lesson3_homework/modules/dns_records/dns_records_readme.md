# DNS Records Module

## Overview
Creates DNS A records that map hostnames to VM IP addresses within the private DNS zone. This allows VMs to communicate using friendly hostnames instead of IP addresses.

## Resources Created
- `google_dns_record_set` - DNS A record mapping hostname to IP address

## Usage

```hcl
module "dns_records" {
  for_each = var.vm_attributes
  source   = "./modules/dns_records"
  
  project_id        = var.project_id
  dns_record_name   = each.value.dns_record_name
  record_type       = var.record_type
  dns_zone_name     = module.dns.managed_zone_name
  dns_zone_dns_name = module.dns.managed_zone_dns_name
  vm_network_ip     = module.gce[each.key].instance_network_ip
}
```

## Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `project_id` | string | yes | gcp project id where the dns record will be created, passed from root variable |
| `dns_record_name` | string | yes | hostname portion without domain (e.g., 'node.monitoring'), comes from vm_attributes map in root module, combined with dns_zone_dns_name to form full domain |
| `record_type` | string | yes | dns record type (e.g., 'A' for ipv4 addresses), passed from root variable, same type used for all vm records |
| `dns_zone_name` | string | yes | resource identifier of the managed zone to add this record to, comes from dns module output (managed_zone_name), not the dns domain |
| `dns_zone_dns_name` | string | yes | actual dns domain suffix with trailing dot (e.g., 'ani.dev.com.'), comes from dns module output (managed_zone_dns_name), appended to dns_record_name to create fqdn |
| `vm_network_ip` | string | yes | internal ip address assigned to the vm instance, comes from gce module output (instance_network_ip) via for_each iteration, this is what the dns record resolves to |

## Outputs

| Output | Type | Description |
|--------|------|-------------|
| `fqdn` | string | fully qualified domain name created for this vm (e.g., 'node.monitoring.ani.dev.com.'), can be used by other vms to connect via dns instead of ip | 
| `ip_address` | string | ip address this dns record points to, same as the vm's internal ip, useful for verification | 
| `record_id` | string | terraform resource identifier for this dns record (format: projects/{{project}}/managedZones/{{zone}}/rrsets/{{name}}/{{type}}), useful for debugging |

## Configuration Details

### FQDN Construction
The full domain name is constructed by combining:
```
{dns_record_name}.{dns_zone_dns_name}
```

Example mappings:
- `node.monitoring` + `ani.dev.com.` = `node.monitoring.ani.dev.com.`

### Record Data (rrdatas)
The DNS record points to the VM's internal IP address from its subnet. Example:
- node-exporter-vm (10.5.0.x) → node.monitoring.ani.dev.com


### Private DNS Resolution
- Records are only resolvable within the VPC
- VMs can use these hostnames to communicate with each other
- External clients cannot resolve these private DNS names

## Dependencies
- **DNS Module** - requires `managed_zone_name` and `managed_zone_dns_name` outputs
- **GCE Module** - requires `instance_network_ip` output (matched by for_each key)

## Notes

- All records are type A (IPv4 address mapping)
- Records use internal IPs, not external IPs
- The trailing dot in `dns_zone_dns_name` is required by DNS standards
- VMs can now communicate using hostnames like `prom.monitoring.ani.dev.com` instead of IP addresses
