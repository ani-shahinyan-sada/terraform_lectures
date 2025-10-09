# GCP Monitoring Infrastructure Module

A Terraform module for deploying a complete monitoring infrastructure on Google Cloud Platform, including Prometheus, Grafana, Loki, Promtail, and Node Exporter.

## Overview

This module creates a comprehensive monitoring stack on GCP with the following components:

- **Prometheus**: Metrics collection and alerting
- **Grafana**: Visualization and dashboards
- **Loki**: Log aggregation system
- **Promtail**: Log shipping agent
- **Node Exporter**: System metrics exporter

All services are deployed as individual VMs with automated startup scripts, internal DNS resolution, and proper firewall rules.

## Resources Created

### Networking
- **VPC Network**: Custom VPC with no auto-created subnets
- **Subnets**: One subnet per VM, configurable CIDR ranges
- **Firewall Rules**: Port access for all monitoring services and SSH
- **DNS Zone**: Private DNS zone for internal service discovery
- **DNS Records**: A records for each VM

### Compute
- **VM Instances**: Individual compute instances for each service
- **Service Account**: Creates a dedicated service account with storage access
- **Startup Scripts**: Automated installation and configuration

### Storage
- **GCS Bucket**: Storage for startup scripts
- **Bucket Objects**: Individual startup scripts per VM
- **IAM Bindings**: Service account permissions for bucket access

### Services Deployed

| Service | Default Port | Purpose |
|---------|--------------|---------|
| Grafana | 3000 | Visualization and dashboards |
| Prometheus | 9090 | Metrics collection |
| Loki | 3100 | Log aggregation |
| Promtail | 9080 | Log shipping |
| Node Exporter | 9100 | System metrics |

## Module Structure

```
modules/startup_task/
├── backend.tf              # Terraform state backend configuration
├── data.tf                 # Data source definitions
├── dns.tf                  # DNS zone and records
├── firewall_rules.tf       # Firewall rule configurations
├── gce.tf                  # VM instance definitions
├── gcs.tf                  # GCS bucket and objects
├── iam.tf                  # IAM bindings
├── providers.tf            # Provider requirements
├── variables.tf            # Input variable definitions
├── vpc.tf                  # VPC and subnet configurations
├── node-script.sh          # Node Exporter installation script
├── prom-script.sh          # Prometheus installation script
├── graf-script.sh          # Grafana installation script
├── loki-script.sh          # Loki installation script
└── promtail-script.sh      # Promtail installation script
```

## Usage

### Basic Usage

```hcl
module "monitoring" {
  source = "./modules/startup_task"

  project_id       = "your-gcp-project-id"
  bucket_name      = "your-unique-bucket-name"
  service_acc_id   = "your-service-account@your-project.iam.gserviceaccount.com"
}
```

### Custom Configuration

```hcl
module "monitoring" {
  source = "./modules/startup_task"

  project_id       = "testing-terraform-module"
  source_tags      = ["monitoring", "production"]
  target_tags      = ["monitoring", "production"]
  image_family     = "ubuntu-2204-lts"
  image_repository = "ubuntu-os-cloud"
  machine_filter   = "name = \"n1-standard-1\""
  bucket_name      = "my-monitoring-scripts-bucket"
  service_acc_id   = "monitoring-sa@testing-terraform-module.iam.gserviceaccount.com"

  vm_attributes = {
    node-exporter-vm = {
      name           = "node-exporter-01"
      zone           = "us-central1-a"
      dns_name       = "node.monitoring"
      startup_script = "node-script.sh"
      subnet = {
        region      = "us-central1"
        subnet_name = "monitoring-subnet-1"
        mask        = "10.5.0.0/24"
      }
    }
  }

  firewall_rules = {
    node-exporter = {
      name  = "allow-node-exporter"
      ports = ["9100"]
    }
    ssh = {
      name  = "allow-ssh"
      ports = ["22"]
    }
  }
}
```

## Input Variables

### Required Variables

| Name | Type | Description |
|------|------|-------------|
| `project_id` | string | GCP project ID where resources will be created |
| `bucket_name` | string | Unique GCS bucket name for startup scripts |
| `service_acc_id` | string | Service account email (used to extract account_id for creation) |

### Optional Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `source_tags` | list(string) | `["foo", "bar"]` | Network tags for VMs |
| `target_tags` | list(string) | `["foo", "bar"]` | Target tags for firewall rules |
| `image_family` | string | `"debian-12"` | VM image family |
| `image_repository` | string | `"debian-cloud"` | VM image repository |
| `machine_filter` | string | `"name = \"n1-standard-1\""` | Machine type filter |
| `region` | string | `"us-central1"` | GCP region |
| `zone` | string | `"us-central1-a"` | GCP zone |
| `vpc_network_name` | string | `"im-sireli-vpc"` | VPC network name |
| `dns-name` | string | `"ani.com."` | DNS zone name |
| `bucket_location` | string | `"US"` | GCS bucket location |

### Complex Variables

#### vm_attributes

Defines VM configurations:

```hcl
vm_attributes = {
  node-vm = {
    name           = "node-exporter-vm"
    startup_script = "node-script.sh"
    zone           = "us-central1-a"
    dns_name       = "node.monitoring"
    subnet = {
      region      = "us-central1"
      subnet_name = "sirelis1-vm"
      mask        = "10.5.0.0/24"
    }
  }
}
```

#### firewall_rules

Defines firewall configurations:

```hcl
firewall_rules = {
  grafana = {
    name  = "allow-grafana"
    ports = ["3000"]
  }
}
```

## Prerequisites

1. **GCP Project**: An existing GCP project with billing enabled
2. **APIs Enabled**:
   - Compute Engine API
   - Cloud Storage API
   - Cloud DNS API
   - IAM Service Account Credentials API
3. **Terraform**: Version 1.0 or higher
4. **GCP Provider**: Version 7.4.0 or higher
5. **IAM Permissions**: User running Terraform needs permissions to create service accounts and assign IAM roles

**Note**: The module creates the service account automatically - you don't need to create it beforehand.

## Service Account Setup

The module automatically creates the service account with the necessary permissions. You only need to provide the desired service account email format in the `service_acc_id` variable:

```hcl
module "monitoring" {
  source         = "./modules/startup_task"
  service_acc_id = "monitoring-sa@your-project-id.iam.gserviceaccount.com"
  # ... other variables
}
```

The module will:
1. Extract the account ID from the email (e.g., `monitoring-sa`)
2. Create the service account in your project
3. Grant it `roles/storage.objectViewer` on the startup scripts bucket
4. Assign it to all VM instances

**No manual service account creation is required.**

## Deployment Steps

1. **Clone or copy the module** to your Terraform project:
   ```bash
   mkdir -p modules/startup_task
   # Copy module files to modules/startup_task/
   ```

2. **Create your root configuration**:
   ```hcl
   # main.tf
   module "monitoring" {
     source         = "./modules/startup_task"
     project_id     = var.project_id
     bucket_name    = var.bucket_name
     service_acc_id = var.service_acc_id
   }
   ```

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Plan the deployment**:
   ```bash
   terraform plan
   ```

5. **Apply the configuration**:
   ```bash
   terraform apply
   ```

## Accessing Services

After deployment, services are accessible via their external IPs:

- **Grafana**: `http://<grafana-vm-ip>:3000` (default login: admin/admin)
- **Prometheus**: `http://<prometheus-vm-ip>:9090`
- **Node Exporter**: `http://<node-exporter-vm-ip>:9100/metrics`
- **Promtail**: `http://<promtail-vm-ip>:9080/metrics`
- **Loki**: `http://<loki-vm-ip>:3100` (API only, access via Grafana)

### Internal DNS

Services can communicate using internal DNS names:
- `node.monitoring.ani.com`
- `prom.monitoring.ani.com`
- `graf.monitoring.ani.com`
- `loki.monitoring.ani.com`
- `promtail.monitoring.ani.com`

## Configuration

### Grafana Data Sources

Grafana is pre-configured with Loki and Prometheus data sources (if using the provided startup script):

- **Loki**: `http://loki.monitoring:3100`
- **Prometheus**: `http://prom.monitoring:9090`

### Promtail Configuration

Promtail is configured to ship logs to Loki at `http://loki.monitoring:3100/loki/api/v1/push`

Default log sources:
- System logs (`/var/log/*log`)
- Syslog
- Auth logs
- Systemd journal

## Firewall Configuration

Default firewall rules allow traffic on the following ports from `0.0.0.0/0`:

| Port | Service |
|------|---------|
| 22 | SSH |
| 3000 | Grafana |
| 9090 | Prometheus |
| 9100 | Node Exporter |
| 3100 | Loki |
| 9080 | Promtail |

**Security Note**: The default configuration allows access from anywhere (`0.0.0.0/0`). For production use, restrict `allowed_source_ranges` to specific IP ranges.

## Troubleshooting

### VMs Not Starting Scripts

1. Check startup script logs:
   ```bash
   gcloud compute ssh <vm-name> --project=<project-id> --zone=<zone>
   sudo journalctl -u google-startup-scripts.service
   ```

2. Verify bucket permissions:
   ```bash
   gsutil ls gs://<bucket-name>
   gsutil cat gs://<bucket-name>/<vm-name>
   ```

### Service Account Issues

The module creates the service account automatically. If you encounter issues:

1. Verify the service account was created:
   ```bash
   gcloud iam service-accounts list --project=<project-id>
   ```

2. Check if the account ID already exists (will cause conflicts):
   ```bash
   gcloud iam service-accounts describe <account-id>@<project-id>.iam.gserviceaccount.com
   ```

3. Ensure you have permissions to create service accounts:
   ```bash
   gcloud projects get-iam-policy <project-id> --flatten="bindings[].members" --filter="bindings.members:<your-email>"
   ```

### Firewall Issues

Verify firewall rules are created and tags match:
```bash
gcloud compute firewall-rules list --project=<project-id>
gcloud compute instances describe <vm-name> --zone=<zone> --format="value(tags.items)"
```

### DNS Resolution

Test DNS resolution from within a VM:
```bash
nslookup loki.monitoring.ani.com
ping loki.monitoring
```

## Customization

### Adding New VMs

Add entries to the `vm_attributes` variable:

```hcl
vm_attributes = {
  custom-vm = {
    name           = "custom-monitoring-vm"
    startup_script = "custom-script.sh"
    zone           = "us-central1-b"
    dns_name       = "custom.monitoring"
    subnet = {
      region      = "us-central1"
      subnet_name = "custom-subnet"
      mask        = "10.10.0.0/24"
    }
  }
}
```

### Adding Firewall Rules

Add entries to the `firewall_rules` variable:

```hcl
firewall_rules = {
  custom-port = {
    name  = "allow-custom-port"
    ports = ["8080"]
  }
}
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning**: This will delete all VMs, networks, firewall rules, and the GCS bucket (if `force_destroy = true`).

## License

This module is provided as-is for educational and demonstration purposes.

## Support

For issues and questions:
1. Check the troubleshooting section
2. Review Terraform logs: `TF_LOG=DEBUG terraform apply`
3. Verify GCP quotas and permissions
