# Copyright 2019 bbbmj.
#

# commitish
TAG = $(shell git describe --tags --always --dirty)

# RELEASE_VERSION is the version of the release
RELEASE_VERSION ?= $(TAG)

# Build and push specific variables.
REGISTRY ?= docker.io
PROJECT  ?= bbbmj
PUSH     ?= docker push

DOCKER_LABELS=--label tidb-ansible.git-describe="$(shell date -u +v%Y%m%d)-$(shell git describe --tags --always --dirty)"

#
# Usage:
#   make           - default to 'container' target
#   make container - build container
#   make lint      - code analysis
#   $ docker login registry -u username -p xxxxx
#   make push      - push container
#

# Please use `make download-kubectl container` to make git describe clean.
container:
	docker build --no-cache -t "$(REGISTRY)/$(PROJECT)/tidb-ansible:$(RELEASE_VERSION)" $(DOCKER_LABELS) .

push: container
	$(PUSH) "$(REGISTRY)/$(PROJECT)/tidb-ansible:$(RELEASE_VERSION)" $(DOCKER_LABELS)

# TODO(bbbmj)
# lint:

.PHONY: container push lint
