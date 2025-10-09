# Firewall Module

## Overview
Creates firewall rules to allow ingress traffic to specific ports for each monitoring service. Each VM gets its own firewall rule tailored to its service requirements.

## Resources Created
- `google_compute_firewall` - Ingress allow rule with protocol and port specifications

## Usage

```hcl
module "firewall" {
  for_each = var.vm_attributes
  source   = "./modules/firewall"
  
  project_id            = var.project_id
  firewall_name         = each.value.firewall_name
  vpc_network_self_link = module.vpc.vpc_network_self_link
  protocol              = var.protocol
  firewall_ports        = each.value.firewall_ports
  allowed_source_ranges = var.allowed_source_ranges
  target_tags           = var.target_tags
}
```

## Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `project_id` | string | yes | gcp project id where the firewall rule will be created, passed from root variable |
| `firewall_name` | string | yes | unique name for this firewall rule, comes from vm_attributes map in root (e.g., 'allow-node-exporter'), must be unique per project |
| `vpc_network_self_link` | string | yes | full resource path of the vpc network to attach this rule to, comes from vpc module output, format: projects/{{project}}/global/networks/{{name}} |
| `protocol` | string | yes | network protocol to allow through firewall (typically 'tcp' or 'udp'), passed from root variable, same for all firewall rules |
| `firewall_ports` | list(string) | yes | list of port numbers to open for this specific vm (e.g., ['9100'] for node exporter), comes from vm_attributes map in root, each vm has different ports |
| `allowed_source_ranges` | list(string) | yes | cidr blocks allowed to connect to these ports (e.g., ['0.0.0.0/0'] allows all internet, or specific vpc ranges), passed from root variable, same for all rules |
| `target_tags` | list(string) | yes | network tags that this firewall rule applies to, passed from root variable, vms must have matching source_tags to receive traffic through this rule |

## Outputs

| Output | Type | Description | 
|--------|------|-------------|
| `firewall_rule_name` | string | name of the created firewall rule, not currently consumed by other modules but useful for verification or additional firewall configurations | 
| `firewall_rule_id` | string | terraform resource identifier for this firewall rule (format: projects/{{project}}/global/firewalls/{{name}}), useful for dependencies or debugging |
## Configuration Details

### Port Configuration by Service
Each monitoring service requires different ports:
- Node Exporter: 9100
- Prometheus: 9090
- Grafana: 3000
- Loki: 3100
- Promtail: 9080

### Network Tags
The firewall rule uses `target_tags` to identify which VMs it applies to. VMs must have matching `source_tags` for the rule to take effect. In this configuration, both are set to `["foo", "bar"]`.

### Source Ranges
`allowed_source_ranges = ["0.0.0.0/0"]` allows traffic from any IP address. For production environments, consider restricting this to:
- Specific VPC CIDR ranges for internal-only access
- Your organization's IP ranges
- Specific trusted networks

## Dependencies
- **VPC Module** - requires `vpc_network_self_link` output

## Notes
- Created via `for_each` loop - one firewall rule per VM
- Each service has different ports based on its monitoring requirements
- VMs must have matching `source_tags` for the firewall rule to apply
- All firewall rules attach to the same VPC network
- Consider tightening `allowed_source_ranges` for production security