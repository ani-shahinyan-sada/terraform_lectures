output "instance_network_ip" {
  value       = google_compute_instance.instance.network_interface[0].network_ip
  description = "the internal network IP of the instance"
}

output "instance_name" {
  value       = google_compute_instance.instance.name
  description = "the name of the instance"
}
