resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = var.cloudrun_service_account
  display_name = var.cloudrunsa_displayname
}

resource "google_cloud_run_service_iam_binding" "binding" {
  location = var.region
  project  = var.project_id
  service  = google_cloud_run_v2_service.cloud-run-app.name
  role     = var.cloudrunrole
  members = [
    var.membersforrole,
  ]

}

resource "google_cloud_run_v2_service" "cloud-run-app" {
  name                = var.cloudrun_service_name
  location            = var.region
  deletion_protection = false
  ingress             = var.ingress # Allows traffic from which sources? (internet, VPC, and Cloud Run services)
  project             = var.project_id
  

  template {
    containers {
      image = var.image
    }

  }
}
