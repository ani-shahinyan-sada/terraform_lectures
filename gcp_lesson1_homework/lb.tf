module "gce-lb-https" {
  source  = "terraform-google-modules/lb-http/google"
  version = "~> 12.0"

  name    = "lb-for-vms"
  project = var.project_id

  firewall_networks = [module.vpc.network_name]
 # load_balancing_scheme = "EXTERNAL_MANAGED"

  create_url_map = false
  url_map        = google_compute_url_map.custom.self_link

  backends = {
    mig1 = {
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
          group = module.mig["mig1"].instance_group
        }
      ]

      iap_config = {
        enable = var.lb_enable_iap
      }
    }
    mig2 = {
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
          group = module.mig["mig2"].instance_group
        }
      ]

      iap_config = {
        enable = var.lb_enable_iap
      }
    }

    cloudrun = {
      protocol   = "HTTP"
      enable_cdn = false



      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group = google_compute_region_network_endpoint_group.neg.self_link
        }
      ]

      iap_config = {
        enable = false
      }
    }
  }
}


#TODO: add the paths for cloudrun and cloudrunfunctions
resource "google_compute_url_map" "custom" {
  name            = "lb-for-vms-url-map"
  project         = var.project_id
  default_service = module.gce-lb-https.backend_services["mig1"].self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = module.gce-lb-https.backend_services["mig1"].self_link

    route_rules {
      priority = 1
      match_rules {
        prefix_match = "/cloudrun"
      }
      route_action {
        url_rewrite {
          path_prefix_rewrite = "/"
        }
      }
      service = module.gce-lb-https.backend_services["cloudrun"].self_link
    }

    route_rules {
      priority = 2
      match_rules {
        prefix_match = "/mig1"
      }
      service = module.gce-lb-https.backend_services["mig1"].self_link
    }

    route_rules {
      priority = 3
      match_rules {
        prefix_match = "/mig2"
      }
      service = module.gce-lb-https.backend_services["mig2"].self_link
    }

  }
}


