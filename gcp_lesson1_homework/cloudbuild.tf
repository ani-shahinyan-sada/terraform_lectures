resource "google_cloudbuild_trigger" "cloud_run_app_trigger" {
  name            = "cloud-run-app-trigger"
  location        = "us-west1"
  project         = var.project_id
  service_account = var.default_service_acc

  repository_event_config {
    repository = var.run_app_repo
    push {
      branch = var.branch
    }
  }

  filename = var.cloudbuild_filename
}
