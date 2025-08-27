# The username/pass to use when POSTing the event to EDA's event stream URL is stored in vault
# Using datasource here. ephemeral is preferred but not supported with actions yet
data "vault_kv_secret_v2" "aap_event_streams_auth" {
  mount = "secret"
  name  = "aap-tf-actions-basic-event-stream"
}

data "aap_inventory" "inventory" {
  name = "Demo Inventory"
  organization_name = "Default"
}

# Create some infrastructure that has an action tied to it
resource "aap_group" "infra" {
  name = "infra"
  inventory_id = data.aap_inventory.inventory.id
}

# TODO: Change this to launch EC2 instances and either have dependent aap_host resources
# or dynamic inventory / inventory sync
resource "aap_host" "host" {
  count = 5
  inventory_id = data.aap_inventory.inventory.id
  groups = toset([resource.aap_group.infra.id])
  name         = "host-${count.index+1}"
  variables = "ansible_connection: local"

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

# This is using a new 'aap_eventstream' data source in the terraform-provider-aap POC
# The purpose is to look up an EDA Event Stream object by ID so that we know its URL when
# we want to send an event later.
data "aap_eventstream" "eventstream" {
  name = "TF Actions Event Stream"
}

# Sample output just to show that we looked up the Event Stream URL with the above datasource
output "event_stream_url" {
  value = data.aap_eventstream.eventstream.url
}

# This is using a new 'aap_eventdispatch' action in the terraform-provider-aap POC
# The purpose is to POST an event with a payload (config) when triggered, and EDA
# is configured with a rulebook to extract these details out of the config and dispatch
# a job
# TODO: With linked resources we can scope the limit to the resource that was just provisioned
action "aap_eventdispatch" "event" {
  config {
    limit = "infra"
    template_type = "job"
    job_template_name = "Demo Job Template"
    organization_name = "Default"

    event_stream_config = {
      # url from the new datasource is working
      url = data.aap_eventstream.eventstream.url
      username = data.vault_kv_secret_v2.aap_event_streams_auth.data.username
      password = data.vault_kv_secret_v2.aap_event_streams_auth.data.password
    }
  }
}
