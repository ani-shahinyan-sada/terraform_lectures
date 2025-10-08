variable "object_name" {
  type        = string
  description = "the name of the object in the bucket"
}

variable "script_source_path" {
  type        = string
  description = "the local path to the script file"
}

variable "bucket_name" {
  type        = string
  description = "the name of the bucket to store the object in"
}
