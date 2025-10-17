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
    vpc_access {
      network_interfaces {
        network    = "projects/${var.project_id}/global/networks/${var.network_name}"
        subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/${module.subnet.subnets["us-west1/subnet-01"].name}"
      }

  }
}
