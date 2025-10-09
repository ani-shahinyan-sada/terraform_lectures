resource "google_dns_managed_zone" "private-zone" {
  name        = var.private-zone-name
  dns_name    = var.dns-name
  description = "This resource creates a private dns zone"

  # controls whether the DNS zone is private 
  # (only accessible within specified networks) or public

  visibility = var.visibility-type #should be set to private

  # defines which VPC networks can access and 
  # resolve DNS records in this private zone

  private_visibility_config {
    networks {

      # grants DNS query access to the specified VPC network

      network_url = var.vpc_network_id
    }
  }
  project = var.project_id
}
