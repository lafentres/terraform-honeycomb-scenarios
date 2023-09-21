terraform {
  required_providers {
    honeycombio = {
      source  = "honeycombio/honeycombio"
      version = "~> 0.15.0"
    }
  }
}

provider "honeycombio" {
  api_url = var.honeycomb_api_url
  api_key = var.honeycomb_api_key
  debug   = true
}

# Creates the dataset to add lots of triggers to
resource "honeycombio_dataset" "lots-of-triggers-dataset" {
  name        = "lots-of-triggers"
  description = "I am a dataset with ${var.trigger_count} triggers"
}

# Creates column to use in the trigger query spec
resource "honeycombio_column" "test-column" {
  name        = "test-column"
  type        = "integer"
  description = "I am a column"
  dataset     = honeycombio_dataset.lots-of-triggers-dataset.name
}

# Creates the query spec to use for the triggers
data "honeycombio_query_specification" "avg-trigger-query-spec" {
  calculation {
    op     = "AVG"
    column = honeycombio_column.test-column.name
  }

  time_range = 1800
}

# Creates the query to use for the triggers
resource "honeycombio_query" "avg-trigger-query" {
  dataset    = honeycombio_dataset.lots-of-triggers-dataset.name
  query_json = data.honeycombio_query_specification.avg-trigger-query-spec.json
}

# Used to generate random names for the triggers
resource "random_pet" "pet" {
  count = var.trigger_count

  prefix    = "the"
  length    = 3
  separator = "-"
}

# Creates triggers in the dataset
resource "honeycombio_trigger" "test-trigger" {
  count = var.trigger_count

  name        = "${count.index}-${random_pet.pet[count.index].id}"
  description = "I am trigger ${count.index}"

  query_id = honeycombio_query.avg-trigger-query.id
  dataset  = honeycombio_dataset.lots-of-triggers-dataset.name

  frequency = 600 // in seconds, 10 minutes

  alert_type = "on_change"

  threshold {
    op    = ">"
    value = 1000
  }

  recipient {
    type   = "email"
    target = "hello@exaple.com"
  }
}
