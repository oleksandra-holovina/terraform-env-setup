output "curis_domain_name" {
  value = aws_route53_zone.curis_dns.name
}

output "curis_zone_id" {
  value = aws_route53_zone.curis_dns.zone_id
}