variable "project_id" {
  type        = string
  description = "The id of the project"
  default     = "norse-study-420315"
}

variable "region" {
  type        = string
  description = "The default compute region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "The default compute zone"
  default     = "us-central1-a"
}