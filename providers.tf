terraform {
  required_providers {
    aap = {
      source  = "ansible/aap"
      version = "~> 1.3.0-prerelease2"
    }
  }
}

# AAP provider configuration
provider "aap" {
  host     = var.aap_host
  username = var.aap_username
  password = var.aap_password
}
