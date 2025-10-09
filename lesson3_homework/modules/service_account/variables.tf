variable "service_account_id" {
  type        = string
  description = "unique identifier for service account , passed from root variable, combined with project to form email: id@project.iam.gserviceaccount.com"
}

variable "service_account_display_name" {
  type        = string
  description = "human-readable name shown in gcp console, passed from root variable, for identification purposes only"
}

variable "project_id" {
  type        = string
  description = "gcp project id where service account will be created, passed from root variable"
}
