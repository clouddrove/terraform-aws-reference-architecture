variable "label_order" {
  description = ""
  default     = ["environment", "name"]
}

variable "environment" {
  description = ""
  default     = "shared"
}

variable "subnet_ids{
    description = ""
    default = ""
}