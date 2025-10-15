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

  }

}
