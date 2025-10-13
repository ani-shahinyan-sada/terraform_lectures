# locals {
#   access_config = {
#     nat_ip       = google_compute_address.ip_address.address
#     network_tier = "PREMIUM"
#   }
# }

# #instance template locals
# # locals {
# #   source_image         = var.source_image != "" ? var.source_image : "rocky-linux-9-optimized-gcp-v20240111"
# #   source_image_family  = var.source_image_family != "" ? var.source_image_family : "rocky-linux-9-optimized-gcp"
# #   source_image_project = var.source_image_project != "" ? var.source_image_project : "rocky-linux-cloud"

# #   boot_disk = [
# #     {
# #       source_image      = var.source_image != "" ? format("${local.source_image_project}/${local.source_image}") : format("${local.source_image_project}/${local.source_image_family}")
# #       disk_size_gb      = var.disk_size_gb
# #       disk_type         = var.disk_type
# #       disk_labels       = var.disk_labels
# #       auto_delete       = var.auto_delete
# #       boot              = "true"
# #       resource_policies = var.disk_resource_policies
# #     },
# #   ]

locals {
    subnetwork1 = "projects/${var.project_id}/regions/${var.region}/subnetworks/${module.subnet.subnets["us-west1/subnet-01"].name}"
    subnetwork2 = "projects/${var.project_id}/regions/${var.region}/subnetworks/${module.subnet.subnets["us-west1/subnet-02"].name}"
}