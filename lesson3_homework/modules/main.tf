module "vpc" {
  source = "./vpc"

  project_id   = var.project_id
  network_name = var.vpc_network_name
  subnets      = var.subnets
}

module "storage" {
  source = "./gcs"

  project_id    = var.project_id
  bucket_name   = var.bucket_name
  location      = var.bucket_location
  force_destroy = var.force_destroy
  bucket_objects = var.bucket_objects
}

module "iam" {
  source = "./iam"

  project_id   = var.project_id
  account_id   = var.account_id
  display_name = var.display_name

  bucket_iam_bindings = {
    scripts_access = {
      bucket = module.storage.bucket_name
      role   = var.role
    }
  }

  depends_on = [module.storage]
}

module "firewall" {
  source = "./firewallrules"

  project_id     = var.project_id
  network        = module.vpc.network_self_link
  protocol       = var.protocol
  source_ranges  = var.allowed_source_ranges
  target_tags    = var.target_tags
  firewall_rules = var.firewall_rules

  depends_on = [module.vpc]
}

module "compute" {
  source = "./gce"

  project_id                = var.project_id
  network                   = module.vpc.network_self_link
  subnets                   = module.vpc.subnet_self_links
  machine_type              = var.machine_type
  boot_disk_image           = var.boot_disk_image
  network_tags              = var.source_tags
  service_account_email     = module.iam.service_account_email
  service_account_scopes    = var.scopes
  startup_script_bucket_url = module.storage.startup_script_base_url
  vm_instances              = var.vm_instances

  depends_on = [module.iam, module.storage]
}

module "dns" {
  source = "./dns"

  project_id   = var.project_id
  zone_name    = var.private_zone_name
  dns_name     = var.dns_name
  visibility   = var.visibility_type
  network      = module.vpc.network_self_link
  record_type  = var.record_type
  vm_instances = var.vm_instances
  external_ips = module.compute.external_ips

  depends_on = [module.compute]
}