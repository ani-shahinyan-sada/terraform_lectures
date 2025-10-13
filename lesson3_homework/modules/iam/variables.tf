variable "project_id" {
  description = "The GCP project ID where the service account will be created"
  type        = string
}

variable "account_id" {
  description = "The account ID for the service account (must be 6-30 characters)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.account_id))
    error_message = "Account ID must be 6-30 characters, start with a letter, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "display_name" {
  description = "The display name for the service account"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the service account"
  type        = string
  default     = "Service account managed by Terraform"
}

variable "bucket_iam_bindings" {
  description = "Map of IAM bindings for GCS buckets. Key is binding name, value contains bucket and role."
  type = map(object({
    bucket = string
    role   = string
  }))
  default = {}
}