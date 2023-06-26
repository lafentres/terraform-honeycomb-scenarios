variable "honeycomb_api_key" {
  description = "API key for Honeycomb"
  type        = string
  sensitive   = true
}

variable "honeycomb_api_url" {
  description = "API URL for Honeycomb"
  type        = string
}

variable "derived_column_count" {
  description = "A count of the number of derived columns to create"
  type        = number
}

