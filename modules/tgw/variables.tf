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

variable "aws_asn" {
  description = "Private ASN for TGW"
  type        = number
  default     = 64512
}

variable "vpc_attachments" {
  description = "Map of VPC attachments to TGW"
  type = map(object({
    vpc_id     = string
    subnet_ids = list(string)
  }))
}

variable "route_table_associations" {
  description = "Map of attachment key to route table key for association"
  type        = map(string)
  default     = {}
}

variable "route_table_propagations" {
  description = "Map of attachment key to list of route table keys to propagate into"
  type        = map(list(string))
  default     = {}
}

variable "tgw_routes" {
  description = "List of TGW routes to add to private route tables"
  type = list(object({
    destination_cidr = string
    tgw_id           = string
  }))
  default = []
}