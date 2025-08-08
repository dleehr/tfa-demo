terraform {
  required_providers {
    aap = {
      source  = "ansible/aap"
      version = "~> 1.2.0"
    }
  }
}

# AAP provider configuration
provider "aap" {
  host     = var.aap_host
  username = var.aap_username
  password = var.aap_password
}
