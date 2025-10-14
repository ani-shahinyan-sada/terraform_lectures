module "firewall_rules" {
  for_each = var.fw_rules

  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.project_id
  network_name = module.vpc.network_name

  rules = [{
    name          = each.value.name
    direction     = var.firewall_direction
    priority      = var.firewall_priority
    source_ranges = each.value.source_ranges
    target_tags   = each.value.target_tags
    allow = [{
      protocol = var.protocol
      ports    = each.value.ports
    }]
    log_config = {
      metadata = var.metadata_config
    }
  }]
}
