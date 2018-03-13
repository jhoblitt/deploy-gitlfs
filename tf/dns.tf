resource "aws_route53_record" "lfs_www" {
  zone_id = "${var.aws_zone_id}"

  name    = "${data.template_file.fqdn.rendered}"
  type    = "A"
  ttl     = "300"
  records = ["${kubernetes_service.ssl_proxy.load_balancer_ingress.0.ip}"]
}
