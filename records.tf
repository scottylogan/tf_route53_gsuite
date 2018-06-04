resource "aws_route53_zone" "main" {
  name = "${var.domain}"
}

resource "aws_route53_record" "ns" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.domain}"
  type    = "NS"
  ttl     = "${var.ns_ttl}"

  records = [
    "${aws_route53_zone.main.name_servers}",
  ]
}

resource "aws_route53_record" "txt" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.domain}"
  type    = "TXT"
  ttl     = "${var.ttl}"

  records = [
    "${compact(split(",", data.template_file.txt_list.rendered))}",
  ]
}

resource "aws_route53_record" "spf" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.domain}"
  type    = "SPF"
  ttl     = "${var.ttl}"

  records = [
    "${var.spf}",
  ]
}

resource "aws_route53_record" "google_dkim" {
  count   = "${var.dkim == "" ? 0 : 1}"
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "google._domainkey.${var.domain}"
  type    = "TXT"
  ttl     = "${var.ttl}"

  records = [
    "v=DKIM1; k=rsa; p=${var.dkim}",
  ]
}

resource "aws_route53_record" "mx" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.domain}"
  type    = "MX"
  ttl     = "${var.ttl}"

  records = [
    "10 ASPMX.L.GOOGLE.COM.",
    "30 ASPMX5.GOOGLEMAIL.COM.",
    "30 ASPMX4.GOOGLEMAIL.COM.",
    "30 ASPMX3.GOOGLEMAIL.COM.",
    "30 ASPMX2.GOOGLEMAIL.COM.",
    "20 ALT2.ASPMX.L.GOOGLE.COM.",
    "20 ALT1.ASPMX.L.GOOGLE.COM.",
  ]
}
