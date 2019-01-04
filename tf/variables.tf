variable "aws_primary_region" {
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
}

variable "domain_name" {
  description = "DNS domain name to use when creating route53 records."
}

variable "service_name" {
  description = "service / unqualified hostname"
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

variable "google_project" {
  description = "google cloud project ID"
}

variable "tls_crt_path" {
  description = "wildcard tls certificate."
}

variable "tls_key_path" {
  description = "wildcard tls private key."
}

variable "gitlfs_image" {
  description = "gitlfs server docker image."
  default     = "docker.io/lsstsqre/gitlfs-server:g7562fb8"
}

variable "github_org" {
  description = "GitHub Organization used for authorization."
}

variable "replicas" {
  description = "Number of instances of the gitlfs server (pods) to run."
  default     = 3
}

locals {
  # remove "<env>-" prefix for production
  dns_prefix = "${replace("${var.env_name}-", "prod-", "")}"

  # Name of google cloud container cluster to deploy into
  gke_cluster_name = "${var.deploy_name}-${var.env_name}"

  fqdn                 = "${local.dns_prefix}${var.service_name}.${var.domain_name}"
  gitlfs_k8s_namespace = "gitlfs"
  tls_crt              = "${file(var.tls_crt_path)}"
  tls_key              = "${file(var.tls_key_path)}"
}
