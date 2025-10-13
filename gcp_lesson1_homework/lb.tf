
module "gce-lb-https" {
  source  = "terraform-google-modules/lb-http/google"
  version = "~> 12.0"
  name    = var.lb_name
  project = var.project_id

  firewall_networks = [module.vpc.network_name]

  backends = {
    default = {
      protocol    = "HTTP"
      port        = var.httpport
      port_name   = var.http_protocol
      timeout_sec = var.lb_timeout_sec
      enable_cdn  = var.lb_enable_cdn

      health_check = {
        request_path = var.lb_health_check_path
        port         = var.lb_health_check_port
      }
      log_config = {
        enable      = true
        sample_rate = var.lb_log_sample_rate
      }
      groups = [
        {
          group = module.managed_instance_group_1.instance_group
        },
        {
          group = module.managed_instance_group_2.instance_group
        },
      ]

      iap_config = {
        enable = var.lb_enable_iap
      }
    }
  }
}