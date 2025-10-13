module "vpc" {
  source  = "terraform-google-modules/network/google//modules/vpc"
  version = "~> 12.0"

  project_id      = var.project_id
  network_name    = var.network_name
  shared_vpc_host = var.shared_vpc_host
  auto_create_subnetworks = false
}
