variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
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

variable "instances" {
  description = "Map of EC2 instances to create"
  type = map(object({
    subnet_id          = string
    security_group_ids = list(string)
    instance_type      = string
  }))
}