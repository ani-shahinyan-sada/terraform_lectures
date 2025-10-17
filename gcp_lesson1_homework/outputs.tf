#vpc outputs
output "vpc_network" {
  value       = module.vpc.network
  description = "The VPC resource being created"
}


output "network_name" {
  value       = module.vpc.network.name
  description = "The name of the VPC being created"
}

output "network_id" {
  value       = module.vpc.network.id
  description = "The ID of the VPC being created"
}

output "network_self_link" {
  value       = module.vpc.network.self_link
  description = "The URI of the VPC being created"
}

#subnets outputs
output "first_subnet_network" {
  value = module.subnet.subnets["us-west1/subnet-01"].network
}

output "second_subnet_network" {
  value = module.subnet.subnets["us-west1/subnet-02"].network
}

# output "health_check_self_links" {
#   description = "All self_links of healthchecks created for the instance group."
#   value       = local.healthchecks
# }

output "cloud-run-name" {
  value = google_cloud_run_v2_service.cloud-run-app.name
}

# output "cloud-run-name" {
#   value = google_cloud_run_v2_service.cloud-run-app.
# }