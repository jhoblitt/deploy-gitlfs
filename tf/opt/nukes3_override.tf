# XXX with tf 0.11.3, force_destroy seems to be unable to handle versioned
# buckets ;this override is useless purging all object versions is implemented.
resource "aws_s3_bucket" "lfs_objects" {
  force_destroy = true
}

resource "aws_s3_bucket" "lfs_objects_log" {
  force_destroy = true
}

resource "aws_s3_bucket" "lfs_objects_backup" {
  force_destroy = true
}

resource "aws_s3_bucket" "lfs_objects_backup_log" {
  force_destroy = true
}
