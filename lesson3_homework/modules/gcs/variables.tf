variable "project_id" {
  description = "The GCP project ID where the bucket will be created"
  type        = string
}

variable "bucket_name" {
  description = "The name of the storage bucket (must be globally unique)"
  type        = string
}

variable "location" {
  description = "The location of the bucket (US, EU, ASIA, or specific region)"
  type        = string
  default     = "US"
}

variable "force_destroy" {
  description = "When deleting the bucket, delete all objects in the bucket first"
  type        = bool
  default     = false
}

variable "bucket_objects" {
  description = "Map of objects to upload to the bucket. Each object must specify name and source file path."
  type = map(object({
    name   = string
    source = string
  }))
  default = {}
}