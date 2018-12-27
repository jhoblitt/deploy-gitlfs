resource "aws_route53_record" "lfs_www" {
  count   = "${var.dns_enable ? 1 : 0}"
  zone_id = "${var.aws_zone_id}"

  name    = "${local.fqdn}"
  type    = "A"
  ttl     = "300"
  records = ["${kubernetes_service.ssl_proxy.load_balancer_ingress.0.ip}"]
}
