variable "ARM_CLIENT_ID" {
  type = string
  default = "$${var.lookup('ARM_CLIENT_ID')}"
}

variable "ARM_CLIENT_SECRET" {
  type = string
  default = "$${var.lookup('ARM_CLIENT_SECRET')}"
}

variable "ARM_SUBSCRIPTION_ID" {
  type = string
  default = "$${var.lookup('ARM_SUBSCRIPTION_ID')}"
}

variable "ARM_TENANT_ID" {
  type = string
  default = "$${var.lookup('ARM_TENANT_ID')}"
}

variable "DATABRICKS_HOST" {
  description = "$${var.lookup('DATABRICKS_HOST')}"
  type        = string
}
