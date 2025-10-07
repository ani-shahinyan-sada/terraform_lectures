output "managed_zone_name" {
  value       = google_dns_managed_zone.private-zone.name
  description = "the name of the managed DNS zone"
}

output "managed_zone_dns_name" {
  value       = google_dns_managed_zone.private-zone.dns_name
  description = "the DNS name of the managed zone"
}
