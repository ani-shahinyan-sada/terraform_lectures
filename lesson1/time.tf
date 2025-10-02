resource "time_static" "example" {
  triggers = {
    passw = random_password.password.result
  }
}

output "current_time" {
  value = time_static.example.rfc3339
}