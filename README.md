deployment for git-lfs
===

[![Build Status](https://travis-ci.org/lsst-sqre/deploy-gitlfs.png)](https://travis-ci.org/lsst-sqre/deploy-gitlfs)

tl;dr
---

    . creds.sh

    cd tf
    make tf-init-s3
    make tls
    ./bin/terraform plan
    ./bin/terraform apply
