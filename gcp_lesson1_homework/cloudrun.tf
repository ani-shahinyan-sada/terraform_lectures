resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = "ci-cloud-run-v2-sa"
  display_name = "Service account for ci-cloud-run-v2"
}

# resource "google_service_account" "sa" {
#   project      = var.project_id
#   account_id   = "ci-cloud-run-v2-sa"
#   display_name = "Service account for ci-cloud-run-v2"
# }

resource "google_cloud_run_service_iam_binding" "binding" {
  location = var.region
  project = var.project_id
  service = google_cloud_run_v2_service.default.name
  role = "roles/run.invoker"
  members = [
    "allUsers",
  ]
  
}

resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service"
  location = var.region
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"
  project = var.project_id

  template {
    containers {
      image = "gcr.io/testing-modules-474322/cloud-run-app:latest"
    }

    vpc_access {
      network_interfaces {
        network    = module.vpc.network_name
        subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/${module.subnet.subnets["us-west1/subnet-01"].name}"
      }
      egress = "PRIVATE_RANGES_ONLY"
    }
  }
}

# module "cloud_run_v2" {
#   source  = "GoogleCloudPlatform/cloud-run/google//modules/v2"
#   version = "~> 0.16"

#   service_name           = "ci-cloud-run-v2"
#   project_id             = var.project_id
#   location               = "us-central1"
#   create_service_account = false
#   service_account        = google_service_account.sa.email

#   cloud_run_deletion_protection = var.cloud_run_deletion_protection
#   containers = [
#     {
#       container_image = "gcr.io/testing-modules-474322/cloud-run-app:latest"
#       container_name  = "cloudrun-app"
#     }
#   ]
# }