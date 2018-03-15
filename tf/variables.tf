#variable "aws_access_key" {
#  description = "AWS access key id."
#}
#
#variable "aws_secret_key" {
#  description = "AWS secret access key."
#}

variable "aws_default_region" {
  description = "Region for s3 bucket with lfs objects."
  default     = "us-east-1"
}

variable "aws_backup_region" {
  description = "Region for s3 bucket with replicated lfs objects."
  default     = "us-west-2"
}

variable "env_name" {
  description = "AWS tag name to use on resources."
  default     = "jhoblitt"
}

variable "aws_zone_id" {
  description = "route53 Hosted Zone ID to manage DNS records in."
  default     = "Z3TH0HRSNU67AM"
}

variable "domain_name" {
  description = "DNS domain name to use when creating route53 records."
  default     = "lsst.codes"
}

variable "service_name" {
  description = "service / unqualifed hostname"
  default     = "git-lfs"
}

# remove "<env>-" prefix for production
data "template_file" "fqdn" {
  template = "${replace("${var.env_name}-${var.service_name}.${var.domain_name}", "prod-", "")}"
}

variable "google_project" {
  default = "plasma-geode-127520"
}
