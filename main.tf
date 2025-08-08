resource "aap_host" "host" {
  inventory_id = 1
  name         = "my-host"

  lifecycle {
    action_trigger {
      events  = [after_create]
      actions = [action.aap_eventdispatch.event]
    }
  }
}

action "aap_eventdispatch" "event" {
  config {
    name = "Hello World!"
  }
}
