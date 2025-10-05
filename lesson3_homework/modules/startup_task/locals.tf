# locals {

#     [for name in 
#     node_script_url = "https://storage.cloud.google.com/${google_storage_bucket.scripts.name}/${google_compute_instance.instances.name}"
#     prom_script_url = "https://storage.cloud.google.com/${google_storage_bucket.scripts.name}/${google_compute_instance.instances.name}"
#     graf_script_url = "https://storage.cloud.google.com/${google_storage_bucket.scripts.name}/${google_compute_instance.instances.name}"
#     promtail_script_url = "https://storage.cloud.google.com/${google_storage_bucket.scripts.name}/${google_compute_instance.instances.name}"
#     loki_script_url =  "https://storage.cloud.google.com/${google_storage_bucket.scripts.name}/${google_compute_instance.instances.name}"
#   }


#  https://storage.cloud.google.com/startupscripts-for-sada-task/grafana-vm 