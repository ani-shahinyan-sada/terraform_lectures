resource "local_sensitive_file" "rand_password" {
  content  = random_password.password.result
  filename = "${path.module}/random-password-${time_static.example.rfc3339}"
}

resource "local_sensitive_file" "priv_key" {
  content  = tls_private_key.rsa-4096-ani.private_key_pem
  filename = "${path.module}/private_key.pem"
}

resource "local_file" "certificate" {
  content  = tls_self_signed_cert.ani.cert_pem
  filename = "${path.module}/self-signed-cert.pem"
}

resource "local_file" "cert_request_pem" {
  content  = tls_cert_request.ani.cert_request_pem
  filename = "${path.module}/cert_request.pem"
}

resource "local_file" "tls_locally_signed_cert" {
  content  = tls_locally_signed_cert.ani_com.ca_cert_pem
  filename = "${path.module}/locally_signed_cert.pem"
}

output tls_locally_signed_cert {
  value = local_file.tls_locally_signed_cert.content_base64sha256
  description = "the value of the locally signed certificate"
}