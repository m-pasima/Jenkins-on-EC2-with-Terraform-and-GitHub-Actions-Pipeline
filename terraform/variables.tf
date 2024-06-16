variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"
}
