resource "aws_route53_zone" "curis-dns" {
  name = var.domain-name
}

resource "aws_route53_record" "curis-a-record" {
  zone_id = aws_route53_zone.curis-dns.id
  name    = var.domain-name
  type    = "A"
  ttl     = var.ttl
  records = [var.ec2-ip]
}

resource "aws_route53_record" "curis-cname-record" {
  zone_id = aws_route53_zone.curis-dns.id
  name    = "www.${var.domain-name}"
  type    = "CNAME"
  ttl     = var.ttl
  records = [var.domain-name]
}