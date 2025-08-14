resource "aap_host" "host" {
  inventory_id = 1
  name         = "my-host"

  lifecycle {
    # This action trigger syntax new in terraform alpha
    # It configures terraform to run the listed actions based
    # on the named lifecycle events: "After creating this resource, run the action"
    action_trigger {
      events  = [after_create]
      actions = [action.aap_eventdispatch.event]
    }
  }
}

# This is using the new 'aap_eventstream' data source in the terraform-provider-aap POC
# The purpose is to look up an EDA Event Stream object by ID so that we have its URL when
# we want to send an event later.
data "aap_eventstream" "eventstream" {
  id = 1
}

# Sample output just to show that we looked up the Event Stream URL with the above datasource
output "event_stream_url" {
  value = data.aap_eventstream.eventstream.url
}

# This is using the new 'aap_eventdispatch' action in the terraform-provider-aap POC
# The purpose is to POST an event with a payload (config) when triggered
# The terraform alpha release doesn't yet support linked resources, but that can
# help focus/clarify these action payloads.
action "aap_eventdispatch" "event" {
  config {
    limit = "infra"
    template_type = "job"
    job_template_name = "Demo Job Template"
    organization_name = "Default"

    event_stream_config = {
      # Note that the URL is nicely dynamic here, but the credentials need to be user-provided
      url = data.aap_eventstream.eventstream.url
      username = "tf-user"
      password = "terrible"
    }
  }
}
