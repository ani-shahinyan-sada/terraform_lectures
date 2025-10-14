resource "google_cloudbuild_trigger" "cloud_run_app_trigger" {
  name            = "cloud-run-app-trigger"
  location        = "us-west1"
  project         = var.project_id
  service_account = "projects/${var.project_id}/serviceAccounts/324188216983-compute@developer.gserviceaccount.com"

  repository_event_config {
    repository = "projects/testing-modules-474322/locations/us-west1/connections/application/repositories/ani-shahinyan-sada-terraform_lectures"
    push {
      branch = "main"
    }
  }

  filename = "cloudbuild.yaml"
}
