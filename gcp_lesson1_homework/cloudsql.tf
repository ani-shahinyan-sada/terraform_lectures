# module "mysql-db" {
#   source              = "terraform-google-modules/sql-db/google//modules/mysql"
#   version             = "~> 26.1"
#   name                = var.db_name
#   database_version    = "MYSQL_8_0"
#   project_id          = var.project_id
#   zone                = var.zone
#   region              = var.region
#   tier                = var.instance_tier
#   deletion_protection = true


#   db_name      = "default"
#   db_charset   = "utf8"
#   db_collation = "default"

#   user_name     = "default"
#   user_password = var.user_password
#   user_host     = "%"

#   ip_configuration = {
#     ipv4_enabled    = false
#     private_network = module.vpc.network_self_link
#     ssl_mode        = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
#     psc_enabled     = true
#     allowed_consumer_projects = var.project_id
#   }
# }

module "mysql" {
  source  = "terraform-google-modules/sql-db/google//modules/mysql"
  version = "~> 26.0"

  name                 = "instancedbfor-cloudrun"
  random_instance_name = true
  project_id           = var.project_id
  database_version     = "MYSQL_8_0"
  region               = "us-central1"

  deletion_protection = false

  // Master configurations
  tier                            = "db-custom-2-7680"
  zone                            = "us-central1-c"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"


  ip_configuration = {
    ipv4_enabled                  = false
    psc_enabled                   = true
    psc_allowed_consumer_projects = [var.project_id]
  }


  backup_configuration = {
    enabled                        = true
    binary_log_enabled             = true
    start_time                     = "20:55"
    location                       = null
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }
  db_name      = "default"
  db_charset   = "utf8mb4"
  db_collation = "utf8mb4_general_ci"
  user_name     = "default"
  user_password = var.user_password
  user_host     = "%"

}
