resource "google_storage_bucket" "bucket" {
  name     = "cloudrunfunctionbucket"
  location = "US"
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/cloud-run-function"
  output_path = "${path.module}/cloud-run-function.zip"
  excludes    = ["__MACOSX", ".DS_Store"]
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_zip.output_path
}

resource "google_cloudfunctions_function" "function" {
  name        = "function-test"
  description = "My function"
  runtime     = "python39"
  region      = "us-west1"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  entry_point = "hello_http"
  trigger_http          = true
  depends_on = [ google_storage_bucket_object.archive ]
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}