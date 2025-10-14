output "zone_name" {
  description = "The name of the DNS managed zone"
  value       = google_dns_managed_zone.private_zone.name
}

output "zone_id" {
  description = "The ID of the DNS managed zone"
  value       = google_dns_managed_zone.private_zone.id
}

output "dns_name" {
  description = "The DNS name of the managed zone"
  value       = google_dns_managed_zone.private_zone.dns_name
}

output "name_servers" {
  description = "The list of nameservers for the managed zone"
  value       = google_dns_managed_zone.private_zone.name_servers
}


output "record_names" {
  description = "List of DNS record names"
  value       = [for record in google_dns_record_set.records : record.name]
}