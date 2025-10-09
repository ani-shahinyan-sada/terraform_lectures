output "managed_zone_name" {
  value       = google_dns_managed_zone.private-zone.name
  description = "resource name of the managed zone, passed to dns_records module to specify which zone to add records to"
}

output "managed_zone_dns_name" {
  value       = google_dns_managed_zone.private-zone.dns_name
  description = "full dns domain with trailing dot (e.g., 'ani.dev.com.'), passed to dns_records module to construct full record names"
}
