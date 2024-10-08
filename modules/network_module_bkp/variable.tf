variable "address_prefixes" {
  description = "Subnet Address Prefix"
  type   = list(string)
  default     = ["10.0.0.0/16"]
}