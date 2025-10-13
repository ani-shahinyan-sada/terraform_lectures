module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.project_id
  network_name = module.vpc.network_name

  rules = [{
    name          = var.http_rule_name #
    direction     = var.firewall_direction
    priority      = var.firewall_priority
    source_ranges = var.http_source_ranges #
    target_tags   = var.http_target_tags #
    allow = [{
      protocol = var.protocol
      ports    = [var.httpport]
    }]
    log_config = {
      metadata = var.metadata_config
    }
    },
    {
      name          = var.health_check_rule_name
      direction     = var.firewall_direction
      priority      = var.firewall_priority
      source_ranges = var.health_check_source_ranges
      target_tags   = var.health_check_target_tags
      allow = [{
        protocol = var.protocol
        ports    = [var.httpport]
      }]
      log_config = {
        metadata = var.metadata_config
      }
    },
    {
      name          = var.ssh_rule_name
      direction     = var.firewall_direction
      priority      = var.firewall_priority
      source_ranges = var.ssh_source_ranges
      target_tags   = var.ssh_target_tags
      allow = [{
        protocol = var.protocol
        ports    = [var.ssh_port]
      }]
      log_config = {
        metadata = var.metadata_config
      }
  }]
}