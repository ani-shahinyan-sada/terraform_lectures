# GCE Module

## Overview
Creates Google Compute Engine (GCE) VM instances for running monitoring services. Each VM is configured with its own subnet, startup script, and network settings.

## Resources Created
- `google_compute_instance` - Virtual machine instance with specified configuration

## Usage

```hcl
module "gce" {
  for_each = var.vm_attributes
  source   = "./modules/gce"
  
  project_id            = var.project_id
  vm_name               = each.value.vm_name
  machine_type          = data.google_compute_machine_types.vm_machine_type.machine_types[0].name
  vm_zone               = each.value.vm_zone
  image_self_link       = data.google_compute_image.vm_image.self_link
  source_tags           = var.source_tags
  vpc_network_self_link = module.vpc.vpc_network_self_link
  subnet_self_link      = module.subnet[each.key].subnet_self_link
  startup_script_url    = module.object[each.key].script_url
  service_account_email = "${var.service_account_id}@${var.project_id}.iam.gserviceaccount.com"
  scopes                = var.scopes
}
```

## Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `project_id` | string | yes | gcp project id where the vm instance will be created, passed from root variable |
| `vm_name` | string | yes | unique name for this compute instance, comes from vm_attributes map in root (e.g., 'node-exporter-vm'), used to identify the vm in gcp console |
| `machine_type` | string | yes | vm hardware specification (cpu/memory), comes from data source google_compute_machine_types in root using machine_filter (e.g., 'n1-standard-1') |
| `vm_zone` | string | yes | gcp zone where this vm will be created, comes from vm_attributes map in root (e.g., 'us-central1-a'), must be within subnet's region |
| `image_self_link` | string | yes | full resource path to os boot disk image, comes from data source google_compute_image in root using image_family and image_repository (e.g., debian-12 from debian-cloud) |
| `source_tags` | list(string) | yes | network tags assigned to this vm instance (e.g., ['foo', 'bar']), passed from root variable, must match firewall target_tags to receive allowed traffic |
| `vpc_network_self_link` | string | yes | full resource path of vpc network for vm's network interface, comes from vpc module output, all vms share the same vpc |
| `subnet_self_link` | string | yes | full resource path of subnet for vm's network interface, comes from corresponding subnet module output via for_each, each vm gets its own dedicated subnet |
| `startup_script_url` | string | yes | gcs url to startup script that runs when vm boots (format: gs://bucket/object), comes from object module output (script_url) via for_each, each vm runs different script |
| `service_account_email` | string | yes | email of service account attached to vm for authentication, constructed in root as 'service_account_id@project_id.iam.gserviceaccount.com', allows vm to access gcs bucket |
| `scopes` | list(string) | yes | oauth2 api access scopes for service account on this vm (e.g., ['cloud-platform'] for full gcp api access), passed from root variable, determines what apis vm can call |

## Outputs

| Output | Type | Description | Used By |
|--------|------|-------------|---------|
| `instance_network_ip` | string | internal private ip address assigned to vm from its subnet range, passed to dns_records module to create A record mapping hostname to this ip | DNS Records module |
| `instance_name` | string | name of the created vm instance, not currently consumed by other modules but useful for verification or additional configurations | Not currently used |

## Configuration Details

### Boot Disk
Each VM is configured with:
- OS image from Debian 12 (debian-cloud/debian-12)
- Image is selected via data source using `image_family` and `image_repository`
- Boot disk is automatically created from the image

### Network Configuration
Each VM has:
- **VPC Network:** Shared across all VMs
- **Subnet:** Dedicated subnet per VM with unique CIDR range
- **Internal IP:** Assigned from subnet's IP range
- **External IP:** Automatically assigned via `access_config` block
- **Network Tags:** Must match firewall `target_tags` to receive traffic

### Startup Script Execution
1. VM boots and reads metadata `startup-script-url`
2. VM authenticates using attached service account
3. VM downloads script from GCS bucket
4. VM executes script to configure monitoring service
5. Service starts running on specified port

### Service Account and Scopes
- **Service Account:** Provides identity for API authentication
- **Scopes:** Define what APIs the VM can access
  - `cloud-platform` = full access to all GCP APIs
  - Consider restricting to specific scopes in production:
    - `storage-ro` for read-only storage access
    - `logging-write` for writing logs
    - `monitoring-write` for writing metrics

## Dependencies
- **VPC Module** - requires `vpc_network_self_link`
- **Subnet Module** - requires `subnet_self_link` (matched by for_each key)
- **Object Module** - requires `script_url` (matched by for_each key)
- **IAM Module** (via depends_on) - ensures service account has bucket permissions

## Notes
- Created via `for_each` loop - one VM per entry in vm_attributes
- Each VM runs a different monitoring service (Prometheus, Grafana, Node Exporter, Loki, Promtail)
- VMs have both internal and external IPs
- Internal IP is used for DNS records and inter-VM communication
- External IP allows internet access (consider removing for production)
- Machine type comes from data source query, not direct variable
- Image is automatically updated to latest Debian 12 release