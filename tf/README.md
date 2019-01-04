# terraform-gitlfs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_backup\_region | Region for s3 bucket with replicated lfs objects. | string | `"us-west-2"` | no |
| aws\_primary\_region | Region for s3 bucket with lfs objects. | string | `"us-east-1"` | no |
| aws\_zone\_id | route53 Hosted Zone ID to manage DNS records in. | string | n/a | yes |
| deploy\_name | Name of deployment. | string | `"git-lfs"` | no |
| dns\_enable | create route53 dns records. | string | `"false"` | no |
| domain\_name | DNS domain name to use when creating route53 records. | string | n/a | yes |
| env\_name | AWS tag name to use on resources. | string | n/a | yes |
| github\_org | GitHub Organization used for authorization. | string | n/a | yes |
| gitlfs\_image | gitlfs server docker image. | string | `"docker.io/lsstsqre/gitlfs-server:g7562fb8"` | no |
| google\_project | google cloud project ID | string | n/a | yes |
| replicas | Number of instances of the gitlfs server (pods) to run. | string | `"3"` | no |
| s3\_force\_destroy | Destroy aws s3 buckets, even if they still contain objects. | string | `"false"` | no |
| service\_name | service / unqualified hostname | string | `"git-lfs"` | no |
| tls\_crt\_path | wildcard tls certificate. | string | n/a | yes |
| tls\_key\_path | wildcard tls private key. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gitlfs\_fqdn | FQDN of gitlfs service. |
| gitlfs\_ip | IP of gitlfs service. |
| gitlfs\_url | URL of gitlfs service. |
| google\_container\_cluster | Name of gke cluster created for gitlfs service. |
| ingress\_ip | IP of nginx-ingress service. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
