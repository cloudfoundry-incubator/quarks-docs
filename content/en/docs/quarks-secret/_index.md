---
title: "Quarks Secret"
linkTitle: "Quarks Secret"
weight: 60
no_list: true
description: >
  Generates Kubernetes secrets, for passwords, SSH keys and SSL certificates from within the cluster.
---

* Backlog: [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/2192232)
* Slack: #quarks-dev on [https://slack.cloudfoundry.org](https://slack.cloudfoundry.org/)
* Docker: https://hub.docker.com/r/cfcontainerization/quarks-secret/tags
* [Helm hub](https://hub.helm.sh/charts/quarks/quarks-secret)
* [Github](https://github.com/cloudfoundry-incubator/quarks-secret)

## Description

Quarks Secret lets you automatically generate secrets such as passwords, certificates and ssh keys, to ease management of credentials in Kubernetes.


## Installation

Add the quarks repository to helm if you haven't already:

```bash
helm repo add quarks https://cloudfoundry-incubator.github.io/quarks-helm/
```

The simplest way to install the latest release of `Quarks Secret`, is by using helm 3 with the default values:

```bash
kubectl create namespace quarks
helm install qsecret quarks/quarks-secret --namespace quarks
```

The operator will watch for `QuarksSecret` resources in a separate namespace from the one it has been deployed to. By default, it creates a namespace `staging` and starts watching it.

A complete list of the chart settings is available [here](https://hub.helm.sh/charts/quarks/quarks-secret).

## Upgrade

Can be managed as a standard helm package:

```bash
helm upgrade --namespace quarks qsecret quarks/quarks-secret
```

 so just be sure to keep your customization in a values file

### Watching multiple namespaces

By default the component will watch for resources created in the `staging` namespace, but it can be configured to watch over multiple namespaces.

[Refer to the quarks-operator instructions](../quarks-operator/install/#multiple-namespaces) as they are shared between all the `Quarks` components.

## Overview of Quarks Secret

A QuarkSecret is a Kubernetes Object that contains instuctions on the type of Kubernetes Secret that must be generated which can be later referenced in a Pod.

For instance, to generate a basic auth password, we can apply the following yaml with `kubectl`:

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/password.yaml" lang="yaml"  options="hl_lines=6">}}

the `type` field denotes the type of secret that should be generated, currently quarks-secret supports the following types:

- `password`
- `certificate`
- `ssh`
- `rsa`
- `basic-auth`
- `dockerconfigjson`
- `copy`
- `templatedconfig`

### Generate credentials

Quarks Secret can be used to generate passwords, certificates and keys. It uses the [cfssl package](https://github.com/cloudflare/cfssl) to generate these. The generated values are stored in kubernetes secrets.

#### Certificates

Example of a `QuarksSecret` resource, which generates a Kubernetes secret containing a certificate:

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/certificate.yaml" lang="yaml">}}

The example can be applied to the namespace where the operator is watching for resources ( `staging` by default )

If a certificate is generated, the Quarks Secret operator ensures that a certificate signing request (CSR) is generated and is approved by the Kubernetes API server.

#### RSA keys

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/rsa.yaml" lang="yaml">}}

#### Basic Authentication

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/basic-auth.yml" lang="yaml">}}


## Examples

The [examples directory](https://github.com/cloudfoundry-incubator/quarks-secret/tree/master/docs/examples) on Github.
