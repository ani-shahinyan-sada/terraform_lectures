resource "random_id" "web_bucket_suffix" {
  byte_length = 4
}

resource "random_id" "bucket_suffix_count" {
  count       = 3
  byte_length = 4
}

resource "random_id" "bucket_suffix" {
  for_each    = var.foreach_buckets
  byte_length = 4
}