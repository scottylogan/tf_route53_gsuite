terraform {
  required_version = ">= 0.12"
}

resource "aws_route53_zone" "main" {
  name = var.domain
  lifecycle {
    prevent_destroy = true
  }
}

output "zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}

resource "aws_route53_record" "ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "NS"
  ttl     = var.ns_ttl

  records = aws_route53_zone.main.name_servers
}

resource "aws_route53_record" "txt" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = var.ttl

  records = compact(split(",", data.template_file.txt_list.rendered))
}

resource "aws_route53_record" "spf" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "SPF"
  ttl     = var.ttl

  records = [
    var.spf,
  ]
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
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = var.ttl
  records = var.mx
}
