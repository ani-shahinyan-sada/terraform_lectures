terraform {
  backend "gcs" {
    bucket = "ani-terraform-state-bucket-homework3"
    prefix = "terraform/state"
  }
}
