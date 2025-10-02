variable "foreach_buckets" {
  description = "Map of bucket values to configuration."
  type        = map(any)
  default = {
    bucket-one = {
      name     = "first-foreach-bucket-terraform-task",
      location = "US",
    },
    bucket-two = {
      name     = "second-foreach-bucket-terraform-task"
      location = "EU",
    }
    bucket-three = {
      name     = "third-foreach-bucket-terraform-task"
      location = "ASIA"
    }
  }
}

variable "web_bucket_name" {
  description = "name of the bucket that hosts the web app"
  default     = "my-web-bucket"
}

variable "location" {
  description = "the location of the web bucket"
  default     = "US"
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects"
  default     = true
}

variable "uniform_bucket_level_access" {
  description = "Enforces IAM-only access control, disabling object-level ACLs"
  default     = true
}

variable "lifecycle_value" {
  description = "boolean to set the lifecycle block value for the web bucket"
  default     = true
  type        = bool
}

variable "project_id" {
  description = "the project ID to use"

}
