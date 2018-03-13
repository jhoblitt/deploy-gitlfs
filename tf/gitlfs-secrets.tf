resource "kubernetes_secret" "gitlfs" {
  metadata {
    name      = "gitlfs"
    namespace = "gitlfs"
  }

  data {
    #AWS_ACCESS_KEY_ID="${var.aws_access_key}"
    #AWS_SECRET_ACCESS_KEY="${var.aws_secret_key}"
    AWS_ACCESS_KEY_ID = "${module.lfs_user.id}"

    AWS_SECRET_ACCESS_KEY = "${module.lfs_user.secret}"
    AWS_REGION            = "${var.aws_default_region}"
    S3_BUCKET             = "${aws_s3_bucket.lfs_objects.id}"
    LFS_SERVER_URL        = "https://${aws_route53_record.lfs_www.fqdn}"
  }
}
