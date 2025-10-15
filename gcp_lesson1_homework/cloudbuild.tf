resource "google_cloudbuild_trigger" "cloud_run_app_trigger" {
  name            = "cloud-run-app-trigger"
  location        = var.region
  project         = var.project_id
  service_account = var.default_service_acc
  
#config on which case will the cloud run get 
#triggered, in our case it is a push to the main branch

  repository_event_config {
    repository = var.run_app_repo
    push {
      branch = var.branch
    }
  }

  filename = var.cloudbuild_filename
}
