resource "google_storage_bucket" "web-bucket" {
  project       = var.project_id
  name          = "${var.web_bucket_name}-${random_id.web_bucket_suffix.hex}"
  location      = var.location
  force_destroy = var.force_destroy

  uniform_bucket_level_access = var.uniform_bucket_level_access
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  lifecycle {
    prevent_destroy = true
  }
}

#turn this into one resource
resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  bucket = google_storage_bucket.web-bucket.name
  source = "index.html"  
  content_type = "text/html"
}

resource "google_storage_bucket_object" "error" {
  name   = "404.html"
  bucket = google_storage_bucket.web-bucket.name
  source = "404.html" 
  content_type = "text/html"
}


resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.web-bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

#with count

resource "google_storage_bucket" "with-count" {
  project       = var.project_id
  name          = "bucket-example-${random_id.bucket_suffix_count[count.index].hex}-with-count-${count.index}"
  location      = "US"
  force_destroy = true
  count         = 3
}

resource "google_storage_bucket" "with-foreach" {
  project                     = var.project_id
  for_each                    = var.foreach_buckets
  name                        = "${each.value.name}-${random_id.bucket_suffix[each.key].hex}-${each.key}"
  location                    = each.value.location
  uniform_bucket_level_access = var.uniform_bucket_level_access
}
