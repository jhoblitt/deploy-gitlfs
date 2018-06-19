provider "aws" {
  version = "~> 1.21"
  region  = "${var.aws_default_region}"
  alias   = "primary"
}

provider "aws" {
  # providers are initialized early and can't use a local var to DRY version
  version = "~> 1.21"
  region  = "${var.aws_backup_region}"
  alias   = "backup"
}

#
# primary bucket
#

# a template is needed to stay DRY while avoiding circular references between
# the object and log buckets
data "template_file" "lfs_objects" {
  template = "${data.template_file.fqdn.rendered}-${var.aws_default_region}"
}

resource "aws_s3_bucket" "lfs_objects" {
  region   = "${var.aws_default_region}"
  bucket   = "${data.template_file.lfs_objects.rendered}"
  provider = "aws.primary"
  acl      = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.lfs_objects_log.id}"
    target_prefix = "log/"
  }

  replication_configuration {
    role = "${aws_iam_role.replication_to_backup.arn}"

    rules {
      id = "replication rule"

      # "" == entire bucket
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.lfs_objects_backup.arn}"
        storage_class = "STANDARD_IA"
      }
    }
  }

  force_destroy = false
}

resource "aws_s3_bucket_metric" "lfs_objects" {
  bucket = "${aws_s3_bucket.lfs_objects.bucket}"
  name   = "EntireBucket"
}

resource "aws_s3_bucket" "lfs_objects_log" {
  region   = "${var.aws_default_region}"
  bucket   = "${data.template_file.lfs_objects.rendered}-logs"
  provider = "aws.primary"
  acl      = "log-delivery-write"

  force_destroy = false
}

#
# replication / backup bucket
#

data "template_file" "lfs_objects_backup" {
  template = "${data.template_file.fqdn.rendered}-${var.aws_backup_region}"
}

resource "aws_s3_bucket" "lfs_objects_backup" {
  region   = "${var.aws_backup_region}"
  bucket   = "${data.template_file.lfs_objects_backup.rendered}"
  provider = "aws.backup"
  acl      = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.lfs_objects_backup_log.id}"
    target_prefix = "log/"
  }

  # XXX broken as aws requires the bucket to already exist
  #replication_configuration {
  #  role = "${aws_iam_role.replication_to_primary.arn}"


  #  rules {
  #    id     = "replication rule"
  #    # "" == entire bucket
  #    prefix = ""
  #    status = "Enabled"


  #    destination {
  #      # "${aws_s3_bucket.lfs_objects.arn}" would create a circular reference.
  #      # See https://github.com/terraform-providers/terraform-provider-aws/issues/749
  #      # so the arn has to be manually constructed
  #      bucket        = "arn:aws:s3:::${data.template_file.lfs_objects.rendered}"
  #      storage_class = "STANDARD"
  #    }
  #  }
  #}

  force_destroy = false
}

resource "aws_s3_bucket_metric" "lfs_objects_backup" {
  bucket = "${aws_s3_bucket.lfs_objects_backup.bucket}"
  name   = "EntireBucket"
}

resource "aws_s3_bucket" "lfs_objects_backup_log" {
  region   = "${var.aws_backup_region}"
  bucket   = "${data.template_file.lfs_objects_backup.rendered}-logs"
  provider = "aws.backup"
  acl      = "log-delivery-write"

  force_destroy = false
}

#
# replication to backup
#

resource "aws_iam_role" "replication_to_backup" {
  name = "${data.template_file.lfs_objects.rendered}-replication_to_backup"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication_to_backup" {
  name = "${aws_s3_bucket.lfs_objects.id}-replication_to_backup"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.lfs_objects.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.lfs_objects.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.lfs_objects_backup.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication_to_backup" {
  name       = "${aws_s3_bucket.lfs_objects.id}-replication_to_backup"
  roles      = ["${aws_iam_role.replication_to_backup.name}"]
  policy_arn = "${aws_iam_policy.replication_to_backup.arn}"
}

#
# replication to primary
#

resource "aws_iam_role" "replication_to_primary" {
  name = "${data.template_file.lfs_objects_backup.rendered}-replication_to_primary"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication_to_primary" {
  name = "${aws_s3_bucket.lfs_objects_backup.id}-replication_to_primary"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.lfs_objects_backup.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.lfs_objects_backup.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.lfs_objects.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication_to_primary" {
  name       = "${aws_s3_bucket.lfs_objects.id}-replication_to_primary"
  roles      = ["${aws_iam_role.replication_to_primary.name}"]
  policy_arn = "${aws_iam_policy.replication_to_primary.arn}"
}

#
# iam user account

module "lfs_user" {
  source = "github.com/lsst-sqre/tf_aws_iam_user"

  name = "${data.template_file.fqdn.rendered}-push"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "${aws_s3_bucket.lfs_objects.arn}/*",
        "${aws_s3_bucket.lfs_objects_backup.arn}/*"
      ]
    },
    {
      "Sid": "2",
      "Effect": "Allow",
      "Action": [
        "s3:ListObjects",
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.lfs_objects.arn}",
        "${aws_s3_bucket.lfs_objects_backup.arn}"
      ]
    }
  ]
}
EOF
}
