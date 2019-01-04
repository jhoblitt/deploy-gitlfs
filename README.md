deployment for git-lfs
===

[![Build Status](https://travis-ci.org/lsst-sqre/deploy-gitlfs.png)](https://travis-ci.org/lsst-sqre/deploy-gitlfs)

This is a "root" module which declares providers and is not intended to be used
for composition.

Usage
---

See [terraform-doc output](tf/README.md) for available arguments and
attributes.

### terragrunt

Example terragrunt [`terraform.tfvars`](https://github.com/lsst-sqre/terragrunt-live-test/blob/master/jhoblitt/gitlfs/terraform.tfvars)

`pre-commit` hooks
---

```bash
go get github.com/segmentio/terraform-docs
pip install --user pre-commit
pre-commit install

# manual run
pre-commit run -a
```

See also:

* [`terraform`](https://www.terraform.io/)
* [`terragrunt`](https://github.com/gruntwork-io/terragrunt)
* [`terraform-docs`](https://github.com/segmentio/terraform-docs)
* [`helm`](https://docs.helm.sh/)
* [`pre-commit`](https://github.com/pre-commit/pre-commit)
* [`pre-commit-terraform`](https://github.com/antonbabenko/pre-commit-terraform)
