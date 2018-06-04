variable "domain" {
  description = "Domain to create"
  type        = "string"
}

variable "ttl" {
  description = "Default DNS record TTL"
  type        = "string"
  default     = "300"
}

variable "ns_ttl" {
  description = "DNS NS record TTL"
  type        = "string"
  default     = "86400"
}

variable "site_verifier" {
  description = "Value for google-site-verification TXT record"
  type        = "string"
  default     = ""
}

variable "spf" {
  description = "SPF Record Value"
  type        = "string"
  default     = "v=spf1 include:_spf.google.com ~all"
}

variable "dkim" {
  description = "Google DKIM Record"
  type        = "string"
  default     = ""
}

variable "extra_txts" {
  description = "Additional TXT record values"
  type        = "list"
  default     = []
}

data "template_file" "txt_list" {
  template = "${var.spf},$${_extra},$${_ver}"

  vars {
    _ver   = "${var.site_verifier == "" ? "" : format("google-site-verification=%s", var.site_verifier)}"
    _extra = "${join(",", var.extra_txts)}"
  }
}

