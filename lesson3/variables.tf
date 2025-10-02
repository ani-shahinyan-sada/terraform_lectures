variable "terraform_static_site_bucket_name" {
    type = "string"
    default = "terraform_static_site"
}

variable "bucket_location" {
    type = "string"
    default = "EU"
}
variable "uniform_bucket_level_access" {
    type = bool
    default = true
}

variable "project_id" {
    type = string
    default = "elevated-column-473707-k5"
}