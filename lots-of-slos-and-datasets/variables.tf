variable "honeycomb_api_key" {
  description = "API key for Honeycomb"
  type        = string
  sensitive   = true
}

variable "honeycomb_api_url" {
  description = "API URL for Honeycomb"
  type        = string
}

variable "slo_dataset_count" {
  description = "A count of the number of slos and datasets to create"
  type        = number
  default     = 5
}
