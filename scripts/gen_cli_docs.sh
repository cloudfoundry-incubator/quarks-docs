#!/bin/bash
set -ex

rm -rf build/ || true
mkdir build/

git clone https://github.com/cloudfoundry-incubator/quarks-operator build/operator
pushd build/operator
    mkdir -p content/en/docs/commands/cf-operator
    go run cmd/gen-command-docs.go content/en/docs/commands/cf-operator/
popd

git clone https://github.com/cloudfoundry-incubator/quarks-job build/quarks-job
pushd build/quarks-job
    mkdir -p content/en/docs/commands/quarks-job
    go run cmd/docs/gen-command-docs.go content/en/docs/commands/quarks-job/
popd

git clone https://github.com/cloudfoundry-incubator/quarks-secret build/quarks-secret
pushd build/quarks-secret
    mkdir -p content/en/docs/commands/quarks-secret
    go run cmd/docs/gen-command-docs.go content/en/docs/commands/quarks-secret/
popd

cp -rf build/operator/content/* content/
cp -rf build/quarks-job/content/* content/
cp -rf build/quarks-secret/content/* content/

rm -rf build/ || true
