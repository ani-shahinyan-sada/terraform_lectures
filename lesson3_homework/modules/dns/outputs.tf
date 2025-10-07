output "managed_zone_name" {
  value       = google_dns_managed_zone.private-zone.name
  description = "the name of the managed DNS zone"
}

output "managed_zone_dns_name" {
  value       = google_dns_managed_zone.private-zone.dns_name
  description = "the DNS name of the managed zone"
}

output "id" {
  description = "the id value of the dns managed zone " 
  value = google_dns_managed_zone.private-zone.id
}

output "managed_zone_id" {
  description = "the numeric id value of the dns managed zone" 
  value = google_dns_managed_zone.private-zone.managed_zone_id
}

output "name_servers" {
  value = google_dns_managed_zone.private-zone.name_servers
  description = "the name servers of the managed zone" 
}