terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.4.0"
    }
    # google-beta = {
    #   source  = "hashicorp/google-beta"
    #   version = "7.4.0"
    # }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
