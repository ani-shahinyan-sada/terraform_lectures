output "ip_address" {
  value       = google_dns_record_set.a.rrdatas[0]
  description = "ip address this dns record points to, same as the vm's internal ip, useful for verification"
}

output "record_id" {
  value       = google_dns_record_set.a.id
  description = "terraform resource identifier for this dns record"
}
