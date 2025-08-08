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

data "aap_eventstream" "eventstream" {
  id = 1
}

action "aap_eventdispatch" "event" {
  config {
    limit = "infra"
    template_type = "job"
    job_template_name = "Demo Job Template"
    organization_name = "Default"

    event_stream_config = {
      url = data.aap_eventstream.eventstream.url
      username = "tf-user"
      password = "terrible"
    }
  }
}
