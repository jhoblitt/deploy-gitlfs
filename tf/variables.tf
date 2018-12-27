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

variable "deploy_name" {
  description = "Name of deployment."
  default     = "git-lfs"
}

variable "dns_enable" {
  description = "create route53 dns records."
  default     = false
}

variable "s3_force_destroy" {
  description = "Destroy aws s3 buckets, even if they still contain objects."
  default     = false
}

# remove "<env>-" prefix for production
data "template_file" "fqdn" {
  template = "${replace("${var.env_name}-${var.service_name}.${var.domain_name}", "prod-", "")}"
}

variable "google_project" {
  description = "google cloud project ID"
  default     = "plasma-geode-127520"
}

# Name of google cloud container cluster to deploy into
data "template_file" "gke_cluster_name" {
  template = "${var.deploy_name}-${var.env_name}"
}
