module "vpc" {
  source = "./modules/vpc"

  project_id       = var.project_id
  vpc_network_name = var.vpc_network_name
}


module "subnet" {
  for_each = var.vm_attributes
  source   = "./modules/subnet"

  project_id            = var.project_id
  vpc_network_self_link = module.vpc.vpc_network_self_link
  subnet_name           = each.value.subnet_name
  subnet_mask           = each.value.subnet_mask
  subnet_region         = each.value.subnet_region
}

module "firewall" {
  for_each = var.vm_attributes
  source   = "./modules/firewall"

  project_id            = var.project_id
  firewall_name         = each.value.firewall_name
  vpc_network_self_link = module.vpc.vpc_network_self_link
  protocol              = var.protocol
  firewall_ports        = each.value.firewall_ports
  allowed_source_ranges = var.allowed_source_ranges
  target_tags           = var.target_tags
}

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

  depends_on = [module.iam]
}

module "bucket" {
  source          = "./modules/bucket"
  bucket_location = var.bucket_location
  bucket_name     = var.bucket_name
  project_id      = var.project_id
  depends_on = [ module.serviceacc ]
}

module "object" {
  source             = "./modules/object"
  for_each           = var.vm_attributes
  object_name        = each.value.vm_name
  script_source_path = "./scripts/${each.value.startup_script}"
  bucket_name        = var.bucket_name
  depends_on         = [module.bucket, module.serviceacc]
}

module "serviceacc" {
  source = "./modules/service_account"
  service_account_display_name = var.service_account_display_name
  project_id = var.project_id
  service_account_id = var.service_account_id
  
}

module "iam" {
  source                = "./modules/iam"
  role                  = var.role
  service_account_email = "${var.service_account_id}@${var.project_id}.iam.gserviceaccount.com"
  bucket_name           = var.bucket_name
  depends_on = [ module.serviceacc ]
}

module "dns" {
  source = "./modules/dns"

  project_id        = var.project_id
  private-zone-name = var.private_zone_name
  dns-name          = var.dns_name
  visibility-type   = var.visibility_type
  vpc_network_id    = module.vpc.vpc_network_id
}

module "dns_records" {
  for_each = var.vm_attributes
  source   = "./modules/dns_records"

  project_id        = var.project_id
  dns_record_name   = each.value.dns_record_name
  record_type       = var.record_type
  dns_zone_name     = module.dns.managed_zone_name
  dns_zone_dns_name = module.dns.managed_zone_dns_name
  vm_network_ip     = module.gce[each.key].instance_network_ip
}
