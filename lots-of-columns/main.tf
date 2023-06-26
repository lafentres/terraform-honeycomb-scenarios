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

locals {
  column_types = ["string", "float", "integer", "boolean"]
}

# Creates the dataset to add lots of columns to
resource "honeycombio_dataset" "lots-of-columns-dataset" {
  name        = "lots-of-columns"
  description = "I am a dataset with ${var.column_count} columns"
}

# Used to generate random names for the columns
resource "random_pet" "pet" {
  count = var.column_count

  prefix    = "the"
  length    = 3
  separator = "-"
}

# Creates columns in the dataset
resource "honeycombio_column" "test-column" {
  count = var.column_count

  name        = "${count.index}-${random_pet.pet[count.index].id}"
  type        = local.column_types[count.index % 4]
  description = "I am column ${count.index}"
  dataset     = honeycombio_dataset.lots-of-columns-dataset.name
}

