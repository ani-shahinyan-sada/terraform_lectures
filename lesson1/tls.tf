resource "tls_private_key" "rsa-4096-ani" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "ani" {
  private_key_pem = file("private_key.pem")

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_cert_request" "ani" {
  private_key_pem = file("private_key.pem")

  subject {
    common_name  = "ani.com"
  }
}

resource "tls_locally_signed_cert" "ani_com" {
  cert_request_pem   = file("cert_request.pem")
  ca_private_key_pem = file("private_key.pem")
  ca_cert_pem        = file("self-signed-cert.pem")

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}