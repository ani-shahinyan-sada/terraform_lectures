# GCP Lesson 1 Homework - Terraform Infrastructure

This project deploys a highly available web application infrastructure on Google Cloud Platform (GCP) using Terraform. It provisions a load-balanced NGINX web server deployment across multiple managed instance groups.

## Architecture Overview

The infrastructure includes:

- **VPC Network**: Custom VPC with two subnets in us-west1
- **Managed Instance Groups (MIGs)**: Two auto-scaling instance groups running NGINX
- **HTTP(S) Load Balancer**: Distributes traffic across both instance groups
- **Cloud NAT**: Enables internet access for private instances
- **Firewall Rules**: Configured for HTTP, SSH, and health check traffic
- **Static External IP**: For the load balancer

## Components

### Network Infrastructure
- Custom VPC network
- Two subnets: `subnet-01` (10.10.10.0/24) and `subnet-02` (10.10.20.0/24)
- Cloud Router with NAT gateway
- Firewall rules for HTTP (port 80), SSH (port 22), and health checks

### Compute Resources
- Two instance templates using Ubuntu 24.04 LTS
- Two managed instance groups with autoscaling capabilities
- Machine type: `e2-micro`
- Startup script: [nginx.sh](nginx.sh) - installs and configures NGINX with a custom landing page

### Load Balancer
- HTTP(S) load balancer with logging enabled
- Health checks on port 80
- Backend timeout: 10 seconds
- Load balancer distributes traffic to both instance groups

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0+
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP Project with billing enabled
- Appropriate IAM permissions to create:
  - Compute Engine instances
  - VPC networks
  - Load balancers
  - Firewall rules

## Required GCP APIs

Enable the following APIs in your GCP project:
```bash
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com
```

## Setup Instructions

### 1. Configure Authentication

```bash
gcloud auth application-default login
```

### 2. Set Up Variables

Create or modify [terraform.tfvars](terraform.tfvars) with your configuration:

```hcl
project_id   = "your-gcp-project-id"
network_name = "your-vpc-name"
region       = "us-west1"

# Instance group configuration
hostname1       = "mig-simple1"
hostname2       = "mig-simple2"
min_replicas1   = 2
max_replicas1   = 4
min_replicas2   = 2
max_replicas2   = 4

# Firewall configuration
http_rule_name              = "allow-http"
health_check_rule_name      = "allow-health-check"
ssh_rule_name               = "allow-ssh"
firewall_direction          = "INGRESS"
http_source_ranges          = ["0.0.0.0/0"]
health_check_source_ranges  = ["35.191.0.0/16", "130.211.0.0/22"]
ssh_source_ranges           = ["0.0.0.0/0"]

# Load balancer configuration
lb_name = "gce-lb-https"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan the Deployment

```bash
terraform plan
```

### 5. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

## Usage

After successful deployment, Terraform will output:

- **Load Balancer IP**: Use this to access your web application
- **VPC Network Details**: Network ID, name, and self-link
- **Instance Group URLs**: Self-links for both managed instance groups

Access your application:
```bash
# Get the load balancer IP from outputs
terraform output

# Access the application (wait 2-3 minutes for instances to be ready)
curl http://<LOAD_BALANCER_IP>
```

You should see a custom NGINX page displaying the internal IP of the serving instance.

## File Structure

```
gcp_lesson1_homework/
├── README.md                      # This file
├── providers.tf                   # GCP provider configuration
├── variables.tf                   # Input variable definitions
├── terraform.tfvars              # Variable values (user-configured)
├── vpc.tf                        # VPC network configuration
├── subnet.tf                     # Subnet configuration
├── nat.tf                        # Cloud NAT configuration
├── firewall_rules.tf             # Firewall rule definitions
├── instance_template.tf          # Instance template configurations
├── mig.tf                        # Managed instance group configurations
├── lb.tf                         # Load balancer configuration
├── ip_address.tf                 # External IP address
├── outputs.tf                    # Output definitions
├── locals.tf                     # Local values
└── nginx.sh                      # Startup script for NGINX installation
```

## Key Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `project_id` | GCP project ID | Required |
| `network_name` | VPC network name | Required |
| `region` | GCP region | `us-west1` |
| `machine_type` | Instance machine type | `e2-micro` |
| `min_replicas1/2` | Minimum instances per group | `null` |
| `max_replicas1/2` | Maximum instances per group | `null` |
| `httpport` | HTTP port | `80` |
| `ssh_port` | SSH port | `22` |

See [variables.tf](variables.tf) for the complete list of configurable variables.

## Outputs

| Output | Description |
|--------|-------------|
| `vpc_network` | The VPC resource created |
| `network_name` | Name of the VPC |
| `network_id` | VPC network ID |
| `network_self_link` | VPC self-link URI |
| `instance_group1/2` | Instance group URLs |
| `self_link1/2` | MIG self-links |

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted to confirm deletion.

## Notes

- The startup script ([nginx.sh](nginx.sh)) installs NGINX and creates a custom landing page showing the VM's internal IP
- Health checks are configured on port 80 with path `/`
- Auto-scaling is enabled for both instance groups
- All instances use Ubuntu 24.04 LTS
- Instances are deployed in private subnets with NAT for internet access

## Troubleshooting

### Load Balancer Not Working
- Wait 2-5 minutes for backend instances to become healthy
- Check firewall rules allow traffic from load balancer health check ranges
- Verify instances are running: `gcloud compute instances list`

### SSH Access Issues
- Ensure SSH firewall rule is configured with appropriate source ranges
- Use Identity-Aware Proxy for secure SSH: `gcloud compute ssh INSTANCE_NAME --tunnel-through-iap`

### Health Check Failures
- Verify NGINX is running on instances
- Check that health check source ranges are allowed in firewall rules
- Review instance startup script logs

## Security Considerations

- Update `ssh_source_ranges` to restrict SSH access to specific IP ranges
- Consider enabling Cloud Armor for DDoS protection
- Use Identity-Aware Proxy (IAP) for secure access instead of opening SSH to 0.0.0.0/0
- Review and restrict firewall rules according to your security requirements

## License

This is a learning project for GCP Lesson 1 Homework.
