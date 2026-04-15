variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_asn" {
  description = "Private ASN for TGW"
  type        = number
  default     = 64512
}

variable "environment" {
  description = "Target environment (prod/staging/dev)"
  type        = string

  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "Environment must be prod, staging, or dev."
  }
}

variable "name_prefix" {
  description = "Prefix applied to all resource names"
  type        = string
}