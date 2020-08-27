#!/bin/bash
set -ex

rm -rf build/ || true
mkdir build/

git clone https://github.com/cloudfoundry-incubator/quarks-operator build/operator
pushd build/operator
    mkdir -p content/en/docs/quarks-operator/CLI
    go run cmd/gen-command-docs.go content/en/docs/quarks-operator/CLI/
popd

git clone https://github.com/cloudfoundry-incubator/quarks-job build/quarks-job
pushd build/quarks-job
    mkdir -p content/en/docs/quarks-job/CLI
    go run cmd/docs/gen-command-docs.go content/en/docs/quarks-job/CLI/
popd

git clone https://github.com/cloudfoundry-incubator/quarks-secret build/quarks-secret
pushd build/quarks-secret
    mkdir -p content/en/docs/quarks-secret/CLI
    go run cmd/docs/gen-command-docs.go content/en/docs/quarks-secret/CLI/
popd

cp -rf build/operator/content/* content/
cp -rf build/quarks-job/content/* content/
cp -rf build/quarks-secret/content/* content/

rm -rf build/ || true
