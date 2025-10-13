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

#instance group outputs

output "self_link1" {
  description = "Self-link of managed instance group"
  value       = module.managed_instance_group_1.self_link
}

output "self_link2" {
  description = "Self-link of managed instance group"
  value       = module.managed_instance_group_2.self_link
}

output "instance_group1" {
  description = "Instance-group url of managed instance group"
  value       = module.managed_instance_group_1.instance_group
}

output "instance_group2" {
  description = "Instance-group url of managed instance group"
  value       = module.managed_instance_group_2.instance_group
}




# output "health_check_self_links" {
#   description = "All self_links of healthchecks created for the instance group."
#   value       = local.healthchecks
# }

