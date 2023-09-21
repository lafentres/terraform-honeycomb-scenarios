variable "honeycomb_api_key" {
  description = "API key for Honeycomb"
  type        = string
  sensitive   = true
}

variable "honeycomb_api_url" {
  description = "API URL for Honeycomb"
  type        = string
}

variable "trigger_count" {
  description = "A count of the number of triggers to create"
  type        = number
}
