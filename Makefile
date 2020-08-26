export HUGO_VERSION?=0.74.3
export HUGO_PLATFORM?=Linux-64bit

export ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL := build

build:
	scripts/build.sh

serve:
	scripts/serve.sh

publish:
	scripts/publish.sh

check404:
	-wget --spider -r -erobots=off -nd -nv -o run1.log http://localhost:1313/
	-grep -B1 'broken link!' run1.log

gen-command-docs:
	scripts/gen_cli_docs.sh
