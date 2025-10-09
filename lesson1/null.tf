# resource "null_resource" "cluster" {
#   triggers = {
#     cluster_instance_ids = join(",", az.input[*])
#   }
# }