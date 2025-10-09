variable "project_id" {
  type        = string
  description = "project where resources are configured"
}

variable "bucket_name" {
  type        = string
  description = "the bucket name for the bucket of the startup_scripts"
}

variable "bucket_location" {
  type        = string
  description = "the location where the bucket is"
}
