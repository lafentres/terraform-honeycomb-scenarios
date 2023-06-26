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
  debug = true
}

# Used to generate random names for the datasets
resource "random_pet" "pet" {
  count = var.dataset_count

  prefix    = "the"
  length    = 3
  separator = "-"
}

# Creates datasets
resource "honeycombio_dataset" "test-dataset" {
  count = var.dataset_count

  name        = "${count.index}-${random_pet.pet[count.index].id}"
  description = "I am dataset ${count.index}"
}

