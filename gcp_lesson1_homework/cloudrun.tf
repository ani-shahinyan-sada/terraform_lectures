resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = "ci-cloud-run-v2-sa"
  display_name = "Service account for ci-cloud-run-v2"
}

module "cloud_run_v2" {
  source  = "GoogleCloudPlatform/cloud-run/google//modules/v2"
  version = "~> 0.16"

  service_name           = "ci-cloud-run-v2"
  project_id             = var.project_id
  location               = "us-central1"
  create_service_account = false
  service_account        = google_service_account.sa.email

  cloud_run_deletion_protection = var.cloud_run_deletion_protection

  containers = [
    {
      container_image = "us-docker.pkg.dev/cloudrun/container/hello"
      container_name  = "hello-world"
    }
  ]
}