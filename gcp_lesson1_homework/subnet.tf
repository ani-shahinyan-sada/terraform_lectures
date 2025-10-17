module "subnet" {
  source       = "terraform-google-modules/network/google//modules/subnets"
  version      = "~> 12.0"
  project_id   = var.project_id
  network_name = module.vpc.network_name

  subnets = var.subnets

  depends_on = [module.vpc]
}
