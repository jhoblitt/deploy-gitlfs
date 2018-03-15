UNAME := $(shell uname -s | tr A-Z a-z)
BIN_DIR = bin
DL_DIR = downloads
ARCH = amd64
TF_PLUG_DIR := .terraform/plugins/$(UNAME)_$(ARCH)

TF_VER = 0.11.3
TF_ZIP_FILE := terraform_$(TF_VER)_$(UNAME)_$(ARCH).zip
TF_ZIP_DL := $(DL_DIR)/$(TF_ZIP_FILE)
TF_BIN := $(BIN_DIR)/terraform

TF_HELM_VER = v0.5.0
TF_HELM_ZIP_FILE := terraform-provider-helm_$(TF_HELM_VER)_$(UNAME)_$(ARCH).tar.gz
TF_HELM_ZIP_DL := $(DL_DIR)/$(TF_HELM_ZIP_FILE)
TF_HELM_BIN := $(TF_PLUG_DIR)/terraform-provider-helm

all: tf-install dhparam.pem lsst-certs
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

tf-install: $(TF_BIN) $(TF_HELM_BIN)

tf-init: tf-install
	$(TF_BIN) init

tf-test: tf-init
	$(TF_BIN) fmt --check=true --diff=true
	$(TF_BIN) validate

lsst-certs:
	git clone ~/Dropbox/lsst-sqre/git/lsst-certs.git/ lsst-certs

tf-fmt:
	$(foreach src, $(wildcard *.tf), $(TF_BIN) fmt $(src);)

clean:
	-rm -rf bin $(TF_HELM_BIN) lsst-certs

# do not cleaning up by default
dhparam.pem:
	openssl dhparam -out $@ 2048

.PHONY: all tf-install tf-test test fmt clean
