module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 13.0"

  for_each = var.migs

  create_service_account = var.create_service_account
  machine_type           = var.machine_type
  name_prefix            = each.value.name_prefix
  project_id             = var.project_id
  region                 = var.region
  startup_script         = file("./nginx-${each.key}.sh")
  source_image_family    = var.source_image_family
  source_image_project   = var.source_image_project

  subnetwork         = "projects/${var.project_id}/regions/${var.region}/subnetworks/${module.subnet.subnets[each.value.subnet_location].name}"
  subnetwork_project = var.project_id
  tags               = var.tags
  network            = module.vpc.network_self_link
}
