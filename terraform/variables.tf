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

variable "event_stream_username" {
  type    = string
  default = "tf-user"
  sensitive = true
}

variable "event_stream_password" {
  type = string
  sensitive = true
}
