module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 13.0"

  for_each = var.migs

  project_id        = var.project_id
  region            = var.region
  hostname          = each.value.hostname
  instance_template = module.instance_template[each.key].self_link

  named_ports = [{
    name = var.http_protocol
    port = var.httpport
  }]

  autoscaling_enabled = true
  max_replicas        = each.value.max_replicas
  min_replicas        = each.value.min_replicas
}
