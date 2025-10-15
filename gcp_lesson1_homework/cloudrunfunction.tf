resource "google_storage_bucket" "bucket" {
  name     = var.cloudrunfunction_bucketname
  location = var.cloudrunfunction_location
}

data "archive_file" "function_zip" {
  type        = var.functionfiletype
  source_dir  = var.source_dir
  output_path = var.output_path
  excludes    = var.excludes
}

resource "google_storage_bucket_object" "archive" {
  name   = var.cloudrunobject_name
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_zip.output_path
}

resource "google_cloudfunctions_function" "function" {
  name        = var.cloudrunfunction_name
  description = var.function_description
  runtime     = var.runtime
  region      = var.region

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  entry_point           = var.entry_point
  trigger_http          = true
  depends_on            = [google_storage_bucket_object.archive]
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = var.invoker_role
  member = var.membersforrole
}
