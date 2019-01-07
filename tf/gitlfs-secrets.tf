resource "kubernetes_secret" "gitlfs" {
  metadata {
    name      = "gitlfs"
    namespace = "${kubernetes_namespace.gitlfs.metadata.0.name}"
  }

  data {
    AWS_ACCESS_KEY_ID     = "${module.lfs_user.id}"
    AWS_SECRET_ACCESS_KEY = "${module.lfs_user.secret}"
    AWS_REGION            = "${var.aws_primary_region}"
    S3_BUCKET             = "${aws_s3_bucket.lfs_objects.id}"
    LFS_SERVER_URL        = "https://${local.fqdn}"
  }
}
