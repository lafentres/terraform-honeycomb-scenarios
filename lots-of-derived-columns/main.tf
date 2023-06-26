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

# Creates the dataset to add lots of derived columns to
resource "honeycombio_dataset" "lots-of-derived-columns-dataset" {
  name        = "lots-of-derived-columns"
  description = "I am a dataset with ${var.derived_column_count} derived columns"
}

# Creates column to use in derived column expression
resource "honeycombio_column" "test-column" {
  name        = "test-column"
  type        = "integer"
  description = "I am a column"
  dataset     = honeycombio_dataset.lots-of-derived-columns-dataset.name
}

# Used to generate random names for the derived columns
resource "random_pet" "pet" {
  count = var.derived_column_count

  prefix    = "the"
  length    = 3
  separator = "-"
}

# Creates derived columns in the dataset
resource "honeycombio_derived_column" "test-derived-column" {
  count = var.derived_column_count

  alias        = "dc.${count.index}-${random_pet.pet[count.index].id}"
  expression   = "LOG10(${format("$%s", honeycombio_column.test-column.name)})"
  description = "I am derived column ${count.index}"
  dataset     = honeycombio_dataset.lots-of-derived-columns-dataset.name
}

