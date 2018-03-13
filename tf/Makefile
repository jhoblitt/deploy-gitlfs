UNAME := $(shell uname -s | tr A-Z a-z)
BIN_DIR = bin
DL_DIR = downloads
TF_VER = 0.11.3
ARCH = amd64
TF_ZIP_FILE := terraform_$(TF_VER)_$(UNAME)_$(ARCH).zip
TF_PLUG_DIR := .terraform/plugins/$(UNAME)_$(ARCH)
TF_BIN := $(BIN_DIR)/terraform
TF_HELM_VER = v0.5.0
TF_HELM_ZIP_FILE = terraform-provider-helm_$(TF_HELM_VER)_$(UNAME)_$(ARCH).tar.gz
TF_HELM_BIN := $(TF_PLUG_DIR)/terraform-provider-helm

.PHONY: all tf fmt clean

all: $(TF_BIN) $(TF_HELM_BIN)

# $< may not be defined because of |
$(TF_BIN): | $(DL_DIR)/$(TF_ZIP_FILE)
	unzip -d $(BIN_DIR) $(DL_DIR)/$(TF_ZIP_FILE)

$(DL_DIR)/$(TF_ZIP_FILE): | $(DL_DIR)
	wget -nc https://releases.hashicorp.com/terraform/$(TF_VER)/$(TF_ZIP_FILE) -O $@

$(TF_HELM_BIN): | $(DL_DIR)/$(TF_HELM_ZIP_FILE)
	tar -x -C $(TF_PLUG_DIR) --strip-components=1 -f $(DL_DIR)/$(TF_HELM_ZIP_FILE)

$(DL_DIR)/$(TF_HELM_ZIP_FILE): | $(TF_PLUG_DIR)
	wget -nc https://github.com/mcuadros/terraform-provider-helm/releases/download/$(TF_HELM_VER)/$(TF_HELM_ZIP_FILE) -O $@

$(BIN_DIR) $(DL_DIR) $(TF_PLUG_DIR):
	mkdir -p $@

tf := $(wildcard *.tf)

fmt:
	$(foreach src, $(tf), $(BIN_DIR)/terraform fmt $(src);)

clean:
	-rm -rf bin $(TF_HELM_BIN)
