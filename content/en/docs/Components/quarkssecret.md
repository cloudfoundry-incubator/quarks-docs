---
title: "Quarks Secret"
linkTitle: "Quarks Secret"
weight: 12
description:
    A QuarksSecret allows the developers to deal with the management of credentials.
---

## Description

A QuarksSecret lets you automatically generate secrets such as passwords, certificates and ssh keys, to ease management of credentials in Kubernetes.

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

QuarksSecret can be used to generate passwords, certificates and keys. It uses the [cfssl package](https://github.com/cloudflare/cfssl) to generate these. The generated values are stored in kubernetes secrets.

### Rotate credentials

The generated credentials can be rotated by specifying its quarkssecret's name in a configmap. The configmap must have the following label:

```
quarks.cloudfoundry.org/secret-rotation
```

### Approve Certificates

In the case, where a certificate is generated, the QuarksSecret ensures that a certificate signing request is generated and is approved by the Kubernetes API server.

### Secret copy

The Quarks Secret operator can copy already existing secrets over different namespaces.

Example of a Quarks Secret `copy` type:

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/copy.yaml" lang="yaml" >}}

The examples copies the `my-username` secret content into `copied-secret-2`  inside the `COPYNAMESPACE` namespace.

The `secretName` let you define the name of the secret that you wish to copy,  the namespace is the same where the `Quarks Secret` is going to be created.

The `copies` section takes a list of secret names and namespaces where the secret will be copied over:
```yaml
  copies:
  - name: copied-secret
    namespace: COPYNAMESPACE
  - name: copied-secret
    namespace: COPYNAMESPACE2
  - name: copied-secret
    namespace: COPYNAMESPACE3
  ...
```

## See also

- [Examples](https://github.com/cloudfoundry-incubator/quarks-secret/tree/master/docs/examples)
- [Quarks Secret Controller architecture](../../development/controllers/quarks_secret/)