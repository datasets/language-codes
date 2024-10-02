# Define the default target
.PHONY: all
all: before_install install script after_script

# Define the branches to run only on 'master'
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

# Tasks
before_install:
	@if [ "$(BRANCH)" = "master" ]; then \
		wget http://www.unicode.org/Public/cldr/latest/core.zip; \
		unzip core.zip; \
		mv common/main/ ./; \
		rm -rf data/; \
	fi

install:
	./language-codes.sh

script:
	php ietf-lanGen.php

after_script:
	npm install data-cli --global
	data push
