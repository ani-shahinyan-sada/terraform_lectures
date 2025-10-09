variable "object_name" {
  type        = string
  description = "name for the object in gcs bucket, set to vm_name from vm_attributes map in root via for_each (e.g., 'node-exporter-vm'), used as identifier in bucket"
}

variable "script_source_path" {
  type        = string
  description = "local filesystem path to startup script file, constructed in main.tf"
}

variable "bucket_name" {
  type        = string
  description = "name of gcs bucket to upload script to, passed from root variable, must match bucket created by bucket module"
}
