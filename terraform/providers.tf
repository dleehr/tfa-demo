terraform {
  required_version = "~> v1.14.0"
  required_providers {
    aap = {
      # Overridden by local dev_overrides, provider built with alpha version of plugin-framework
      source  = "ansible/aap"
      version = "~> 1.3.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "5.2.1"
    }
  }
}

provider "vault" {
  skip_child_token = true
  address = var.vault_address
  namespace = var.vault_namespace
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = var.login_approle_role_id
      secret_id = var.login_approle_secret_id
    }
  }
}

# AAP provider configuration
provider "aap" {
  host     = var.aap_host
  username = var.aap_username
  password = var.aap_password
}
