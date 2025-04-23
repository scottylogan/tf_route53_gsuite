variable "domain" {
  description = "Domain to create"
  type        = string
}

variable "ttl" {
  description = "Default DNS record TTL"
  type        = string
  default     = "300"
}

variable "ns_ttl" {
  description = "DNS NS record TTL"
  type        = string
  default     = "86400"
}

variable "site_verifier" {
  description = "Value for google-site-verification TXT record"
  type        = string
  default     = ""
}

variable "mx" {
  description = "MX records for domain"
  type        = list(string)
  default     = [
    "10 ASPMX.L.GOOGLE.COM.",
    "30 ASPMX5.GOOGLEMAIL.COM.",
    "30 ASPMX4.GOOGLEMAIL.COM.",
    "30 ASPMX3.GOOGLEMAIL.COM.",
    "30 ASPMX2.GOOGLEMAIL.COM.",
    "20 ALT2.ASPMX.L.GOOGLE.COM.",
    "20 ALT1.ASPMX.L.GOOGLE.COM.",
  ]
}

variable "spf" {
  description = "SPF Record Value"
  type        = string
  default     = "v=spf1 include:_spf.google.com ~all"
}

variable "dkim" {
  description = "Google DKIM Record"
  type        = string
  default     = ""
}

variable "extra_txts" {
  description = "Additional TXT record values"
  type        = list(string)
  default     = []
}

