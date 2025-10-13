

module "managed_instance_group_1" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 13.0"

  project_id        = var.project_id
  region            = var.region
  hostname          = var.hostname1
  instance_template = module.instance_template1.self_link

  named_ports = [{
    name = var.http_protocol
    port = var.httpport
  }]
  autoscaling_enabled = true
  max_replicas        = var.max_replicas1
  min_replicas        = var.min_replicas1
}

module "managed_instance_group_2" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 13.0"

  project_id        = var.project_id
  region            = var.region
  hostname          = var.hostname2
  instance_template = module.instance_template2.self_link

  named_ports = [{
    name = var.http_protocol
    port = var.httpport
  }]
  autoscaling_enabled = true
  max_replicas        = var.max_replicas2
  min_replicas        = var.min_replicas2
}
