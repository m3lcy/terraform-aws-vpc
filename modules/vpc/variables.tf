variable "vpc_cidr" {
  description = "The CIDR block for the enterprise VPC"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Must be a valid IPv4 CIDR block."
  }
}

variable "environment" {
  description = "Target environment (prod/staging/dev)"
  type        = string

  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "Environment must be prod, staging, or dev."
  }
}

variable "subnet_config" {
  description = "Map of subnet configurations (VLAN mapping)"
  type = map(object({
    cidr_block = string
    az         = string
    is_public  = bool
  }))
}

variable "name_prefix" {
  description = "Prefix applied to all resource names"
  type        = string
}

variable "management_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH into the management security group. Use [] to disable SSH access."
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Create NAT gateways"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs to S3"
  type        = bool
  default     = false
}

variable "flow_log_traffic_type" {
  description = "Type of traffic to capture: ACCEPT, REJECT, or ALL"
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_traffic_type)
    error_message = "flow_log_traffic_type must be ACCEPT, REJECT, or ALL."
  }
}

variable "tgw_routes" {
  description = "List of TGW routes to add to private route tables"
  type = list(object({
    destination_cidr = string
    tgw_id           = string
  }))
  default = []
}

variable "trusted_cidrs" {
  description = "List of trusted CIDRS allowed to SSH into mgmt SG for cross VPC access"
  type = list(string)
  default = []
}