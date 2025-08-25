# AAP variables

variable "aap_password" {
  type = string
  sensitive = true
}

variable "aap_username" {
  type    = string
  default = "admin"
  sensitive = true
}

variable "aap_host" {
  type = string
}

# vault variables

variable vault_address {
  type = string
}

variable login_approle_role_id {
  type = string
}
variable login_approle_secret_id {
  type = string
}
variable vault_namespace {
  type = string
}

variable aap_event_stream_username {
  type = string
}

variable aap_event_stream_password {
  type = string
}
