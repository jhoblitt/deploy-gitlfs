UNAME := $(shell uname -s | tr A-Z a-z)
BIN_DIR = bin
DL_DIR = downloads
ARCH = amd64
TF_PLUG_DIR := .terraform/plugins/$(UNAME)_$(ARCH)

TF_VER = 0.11.7
TF_ZIP_FILE := terraform_$(TF_VER)_$(UNAME)_$(ARCH).zip
TF_ZIP_DL := $(DL_DIR)/$(TF_ZIP_FILE)
TF_BIN := $(BIN_DIR)/terraform

TF_HELM_VER = v0.5.0
TF_HELM_ZIP_FILE := terraform-provider-helm_$(TF_HELM_VER)_$(UNAME)_$(ARCH).tar.gz
TF_HELM_ZIP_DL := $(DL_DIR)/$(TF_HELM_ZIP_FILE)
TF_HELM_BIN := $(TF_PLUG_DIR)/terraform-provider-helm

# these default values must be in sync with the definitions variables.tf
TF_VAR_service_name ?= git-lfs
TF_VAR_domain_name ?= lsst.codes
AWS_DEFAULT_REGION ?= us-east-1
FQDN := $(subst prod-,,$(TF_VAR_env_name)-$(TF_VAR_service_name).$(TF_VAR_domain_name))
TF_S3_BCKT := $(FQDN)-tf

.PHONY: all test
all: tf-install
test: tf-test

# $< may not be defined because of |
$(TF_BIN): | $(TF_ZIP_DL)
	unzip -d $(BIN_DIR) $(TF_ZIP_DL)

$(TF_ZIP_DL): | $(DL_DIR)
	wget -nc https://releases.hashicorp.com/terraform/$(TF_VER)/$(TF_ZIP_FILE) -O $@

$(TF_HELM_BIN): | $(TF_HELM_ZIP_DL)
	tar -x -C $(TF_PLUG_DIR) --strip-components=1 -f $(DL_DIR)/$(TF_HELM_ZIP_FILE)

$(TF_HELM_ZIP_DL): | $(TF_PLUG_DIR)
	wget -nc https://github.com/mcuadros/terraform-provider-helm/releases/download/$(TF_HELM_VER)/$(TF_HELM_ZIP_FILE) -O $@

$(BIN_DIR) $(DL_DIR) $(TF_PLUG_DIR):
	mkdir -p $@

.PHONY: tf-install
tf-install: $(TF_BIN) $(TF_HELM_BIN)

.PHONY: tf-s3-mb
tf-s3-mb:
	aws s3 mb s3://$(TF_S3_BCKT) --region $(AWS_DEFAULT_REGION)

.PHONY: tf-init-s3
tf-init-s3: tf-install tf-s3-mb
	$(TF_BIN) init \
		-backend=true \
		-backend-config="region=$(AWS_DEFAULT_REGION)" \
		-backend-config="bucket=$(TF_S3_BCKT)" \
		-backend-config="key=gitlfs/terraform.tfstate" \
		-input=false \
		-get=true \
		-reconfigure \
		-force-copy

# XXX causes error looking for helm provider
#-upgrade=true \

.PHONY: tf-init
tf-init: tf-install
	$(TF_BIN) init \
		-backend=false \
		-get=true

# XXX causes error looking for helm provider
#-upgrade=true \

.PHONY: tf-test
tf-test: tf-init tf-fmt tf-validate

.PHONY: tf-fmt
tf-fmt:
	$(TF_BIN) fmt --check=true --diff=true

.PHONY: tf-validate
tf-validate:
	$(TF_BIN) validate --check-variables=false

.PHONY: tls
tls: dhparam.pem lsst-certs

tls-clean:
	-rm -rf lsst-certs

lsst-certs:
	git clone ~/Dropbox/lsst-sqre/git/lsst-certs.git/ lsst-certs

# do not cleaning up by default
dhparam.pem:
	openssl dhparam -out $@ 2048

.PHONY: clean
clean: tls-clean
	-rm -rf $(BIN_DIR) $(TF_HELM_BIN)

define OPT_TEMPLATE
.PHONY: $(1)
$(1): opt/$(2).tf
	-cp $$< $(2).tf

.PHONY: no$(1)
no$(1):
	-rm $(2).tf
endef

$(eval $(call OPT_TEMPLATE,dns,dns))
$(eval $(call OPT_TEMPLATE,nukes3,nukes3_override))
