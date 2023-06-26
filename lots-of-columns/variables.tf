variable "honeycomb_api_key" {
  description = "API key for Honeycomb"
  type        = string
  sensitive   = true
}

variable "honeycomb_api_url" {
  description = "API URL for Honeycomb"
  type        = string
}

variable "column_count" {
  description = "A count of the number of columns to create"
  type        = number
}
