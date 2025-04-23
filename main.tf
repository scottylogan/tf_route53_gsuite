terraform {
  required_version = ">= 0.12"
}

resource "aws_route53_zone" "main" {
  name = var.domain
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "NS"
  ttl     = var.ns_ttl

  records = aws_route53_zone.main.name_servers
}

locals {
  ver = var.site_verifier == "" ? [] : [ format("google-site-verification=%s", var.site_verifier) ]
}

resource "aws_route53_record" "txt" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = var.ttl

  records = concat([ var.spf ], local.ver, var.extra_txts)
}

resource "aws_route53_record" "spf" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "SPF"
  ttl     = var.ttl

  records = [ var.spf ]
}

resource "aws_route53_record" "google_dkim" {
  count   = var.dkim == "" ? 0 : 1
  zone_id = aws_route53_zone.main.zone_id
  name    = "google._domainkey.${var.domain}"
  type    = "TXT"
  ttl     = var.ttl

  records = [
    "v=DKIM1; k=rsa; p=${var.dkim}",
  ]
}

resource "aws_route53_record" "mx" {
  count   = length(var.mx) == 0 ? 0 : 1
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = var.ttl
  records = var.mx
}
