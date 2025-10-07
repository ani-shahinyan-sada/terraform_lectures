variable "bucket_name" {
  type        = string
  description = "the name of the GCS bucket"
}

variable "role" {
  type        = string
  description = "the IAM role to grant"
}

variable "service_account_email" {
  type        = string
  description = "the email of the service account"
}
