```markdown
# Monitoring Stack Firewall Example

This example creates firewall rules for a complete monitoring stack including Grafana, Prometheus, Loki, Promtail, and Node Exporter.

## Usage

To run this example:

```bash
terraform init
terraform plan
terraform apply
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| project_id | The GCP project ID | `string` | yes |
| network_name | The name of the VPC network | `string` | yes |

## Outputs

This example outputs all firewall rule details created by the module.
```

---

## How to Use This Module in Your Root Configuration

In your root `main.tf`:

```hcl
# First create your network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
}

# Then create firewall rules
module "firewall" {
  source = "./modules/firewall"

  project_id = var.project_id
  network    = google_compute_network.vpc_network.self_link
  
  protocol      = "tcp"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["foo", "bar"]

  firewall_rules = {
    grafana = {
      name  = "allow-grafana"
      ports = ["3000"]
    }
    prometheus = {
      name  = "allow-prometheus"
      ports = ["9090"]
    }
    node-exporter = {
      name  = "allow-node-exporter"
      ports = ["9100"]
    }
    loki = {
      name  = "allow-loki"
      ports = ["3100"]
    }
    promtail = {
      name  = "allow-promtail"
      ports = ["9080"]
    }
    ssh = {
      name  = "allow-ssh-access"
      ports = ["22"]
    }
  }
}
```

## Module Outputs Usage

```hcl
# Get all firewall rule names
output "all_firewall_rules" {
  value = module.firewall.firewall_rule_names
}

# Get specific firewall rule ID
output "grafana_firewall_id" {
  value = module.firewall.firewall_rule_ids["grafana"]
}
```
```