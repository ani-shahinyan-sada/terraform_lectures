terraform {
  backend "gcs" {
    bucket = "state-for-mig-task-ani"
    prefix = "terraform/state"
  }
}