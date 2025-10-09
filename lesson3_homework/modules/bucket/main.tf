resource "google_storage_bucket" "scripts" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = false #delete objets in the buckets before deleting the bucket
  project       = var.project_id

  uniform_bucket_level_access = true
  #unifies access management by disabling Access Control Lists (ACLs)
  #and using only Identity and Access Management (IAM)
  #policies to control permissions for the entire bucket and its objects
}

