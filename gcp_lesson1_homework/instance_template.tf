module "instance_template1" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 13.0"

  create_service_account = var.create_service_account
  machine_type           = var.machine_type
  name_prefix            = var.instance_template1_name_prefix
  project_id             = var.project_id
  region                 = var.region
  startup_script         = file(var.startup_script_path)
  source_image_family    = var.source_image_family
  source_image_project   = var.source_image_project

  subnetwork         = local.subnetwork1
  subnetwork_project = var.project_id
  tags               = var.tags
  network            = module.vpc.network_self_link

}

module "instance_template2" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 13.0"

  create_service_account = var.create_service_account
  machine_type           = var.machine_type
  name_prefix            = var.instance_template2_name_prefix
  project_id             = var.project_id
  region                 = var.region
  startup_script         = file(var.startup_script_path)
  source_image_family    = var.source_image_family
  source_image_project   = var.source_image_project
  subnetwork             = local.subnetwork2
  subnetwork_project     = var.project_id
  tags                   = var.tags
  network                = module.vpc.network_self_link

}
