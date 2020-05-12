resource "aws_route53_zone" "curis_dns" {
  name = var.domain_name
}

resource "aws_route53_record" "curis_a_record" {
  zone_id = aws_route53_zone.curis_dns.id
  name    = var.domain_name
  type    = "A"
  ttl     = var.ttl
  records = [
    var.ec2_ip]
}

resource "aws_route53_record" "curis_cname_record" {
  zone_id = aws_route53_zone.curis_dns.id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = var.ttl
  records = [
    var.domain_name]
}

resource "aws_route53_record" "curis_ns_records" {
  zone_id = aws_route53_zone.curis_dns.id
  name = var.domain_name
  type = "NS"
  allow_overwrite = true
  ttl     = var.ttl

  records = var.ns_records
}