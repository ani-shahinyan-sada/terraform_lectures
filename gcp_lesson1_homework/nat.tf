resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = module.vpc.network_id
  project = var.project_id
}

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  project_id = var.project_id
  region     = var.region
  router     = google_compute_router.router.name
}