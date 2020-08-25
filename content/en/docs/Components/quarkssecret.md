---
title: "Quarks Secret"
linkTitle: "Quarks Secret"
weight: 12
description:
    A QuarksSecret allows the developers to deal with the management of credentials.
---

## Description

A QuarksSecret lets you automatically generate secrets such as passwords, certificates and ssh keys, to ease management of credentials in Kubernetes.


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

It is possible to configure Quarks Secret to watch over different namespaces, [refer to the quarks-operator instructions](../../core-tasks/install/#multiple-namespaces) as they are share between all the `Quarks` components.

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

### Generate credentials

`QuarksSecret` can be used to generate passwords, certificates and keys. It uses the [cfssl package](https://github.com/cloudflare/cfssl) to generate these. The generated values are stored in kubernetes secrets.

#### Certificates
Example of a `QuarksSecret` which generates a Kubernetes secret containing a certificate:
{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/certificate.yaml" lang="yaml">}}

The example can be applied to the namespace where the operator is watching for resources ( `staging` by default )

#### RSA keys
{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/rsa.yaml" lang="yaml">}}

#### Basic Authentication
{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/basic-auth.yml" lang="yaml">}}

### Rotate credentials

The generated credentials can be rotated by specifying its quarkssecret's name in a configmap. The configmap must have the label```quarks.cloudfoundry.org/secret-rotation```, for example as you can see in **Line 7**:
{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/rotate.yaml" lang="yaml" options="hl_lines=7">}}

### Approve Certificates

In the case, where a certificate is generated, the QuarksSecret ensures that a certificate signing request is generated and is approved by the Kubernetes API server.


### Secret copy

The Quarks Secret operator can generate also copies in multiple namespaces while generating secrets.

For example, while generating passwords:

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/copy.yaml" lang="yaml" >}}

It can be specified a  list of copying target, with `copies`:

```yaml
  copies:
  - name: copied-secret
    namespace: namespace1
```

And each destination which is indicated needs to have a `Quarks Secret` of `copy` in the following form:

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/copy-qsecret-destination.yaml" lang="yaml" >}}


The examples copies the generated `gen-secret` secret content into `copied-secret`  inside the `COPYNAMESPACE` namespace.

## See also

- [Examples](https://github.com/cloudfoundry-incubator/quarks-secret/tree/master/docs/examples)
- [Quarks Secret Controller architecture](../../development/controllers/quarks_secret/)
- [Helm hub](https://hub.helm.sh/charts/quarks/quarks-secret)
- [Github](https://github.com/cloudfoundry-incubator/quarks-job)