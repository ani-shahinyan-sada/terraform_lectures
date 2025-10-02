resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "?+="
}

# resource "random_bytes" "ani_secret" {
#   length = 64
# }

resource "random_id" "server" {
  byte_length = 8
}

output "random_uuid" {
  value = random_id.server.id
}

resource "random_integer" "priority" {
  min = 1
  max = 1000000
}

output "random_integer" {
  value = random_integer.priority.result

}

# resource "random_pet" "server" {
# }

# resource "random_shuffle" "az" {
#   input        = ["us-west-1a", "us-west-1c", "us-west-1d", "us-west-1e"]
#   result_count = 2
# }

resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$!+="
}

output "random_string" {
  value       = random_string.random.result
  description = "the value obtained by the random string generation"
}
# resource "random_uuid" "test" {
# }
