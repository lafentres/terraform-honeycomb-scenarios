terraform {
  required_providers {
    honeycombio = {
      source  = "honeycombio/honeycombio"
      version = "~> 0.23.0"
    }
  }
}

provider "honeycombio" {
  api_url = var.honeycomb_api_url
  api_key = var.honeycomb_api_key
  debug   = true
}

data "honeycombio_auth_metadata" "current" {}

# Generate random names for the datasets
resource "random_pet" "pet" {
  count = var.slo_dataset_count

  prefix    = "the"
  length    = 3
  separator = "-"
}

# Create all the datasets
resource "honeycombio_dataset" "test-dataset" {
  count = var.slo_dataset_count

  name        = "${count.index}-${random_pet.pet[count.index].id}-dataset"
  description = "I am dataset ${count.index}"
}

# Create columns in each dataset
resource "honeycombio_column" "test-column" {
  count = var.slo_dataset_count

  name        = "column.${count.index}"
  type        = "integer"
  description = "I am a column for dataset ${honeycombio_dataset.test-dataset[count.index].name}"
  dataset     = honeycombio_dataset.test-dataset[count.index].name
}

# Create SLI derived columns in each dataset, using the columns created previously
resource "honeycombio_derived_column" "test-sli-derived-column" {
  count = var.slo_dataset_count

  alias       = "sli.${count.index}"
  expression  = format("LTE($%s, 100)", honeycombio_column.test-column[count.index].name)
  description = "I am an SLI derived column for dataset ${honeycombio_dataset.test-dataset[count.index].name}"
  dataset     = honeycombio_dataset.test-dataset[count.index].name
}

# Create an SLO in each dataset
resource "honeycombio_slo" "test-slo" {
  count = var.slo_dataset_count

  name        = "Test SLO: ${count.index}"
  description = "I am a test SLO for SLI sli.${count.index}"
  dataset     = honeycombio_dataset.test-dataset[count.index].name

  sli               = honeycombio_derived_column.test-sli-derived-column[count.index].alias
  target_percentage = 99.9
  time_period       = 30
}

