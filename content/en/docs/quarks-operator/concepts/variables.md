---
title: "BOSH Variables"
linkTitle: "BOSH Variables"
weight: 20
description: >
  How Quarks Operator interpolates BOSH variables.
---

BOSH releases consume two types of variables, explicit and implicit ones.

### Implicit Variables

Implicit variables have to be created before creating a BOSH deployment resource.
The example creates a secret named `var-custom-password`. That value will be used to fill `((custom-password))` place holders in the BOSH manifest.

{{<githubembed repo="cloudfoundry-incubator/quarks-operator" file="docs/examples/bosh-deployment/boshdeployment-with-custom-variable.yaml" lang="yaml">}}

The name of the secret has to follow this scheme: 'var-<variable-name>'

Missing implicit variables are treated as an error.

### Explicit Variables

Explicit variables are explicitly defined in the [BOSH manifest](https://bosh.io/docs/manifest-v2/#variables). They are generated automatically upon deployment and stored in secrets.

The naming scheme is the same as for implicit variables.

If an explicit variable secret already exists, it will not be generated. This allows users to set their own passwords, etc.
