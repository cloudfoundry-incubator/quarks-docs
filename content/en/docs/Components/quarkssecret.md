---
title: "Quarks Secret"
linkTitle: "Quarks Secret"
weight: 12
description:
    A QuarksSecret allows the developers to deal with the management of credentials.
---

- [QuarksSecret](#quarkssecret)
  - [Description](#description)
  - [Features](#features)
    - [Generate credentials](#generate-credentials)
    - [Rotate credentials](#rotate-credentials)
    - [Approve Certificates](#approve-certificates)
  - [`QuarksSecret` Examples](#quarkssecret-examples)

## Description

A QuarksSecret allows the developers to deal with the management of credentials.

## Features

### Generate credentials

QuarksSecret can be used to generate passwords, certificates and keys. It uses the [cfssl package](https://github.com/cloudflare/cfssl) to generate these. The generated values are stored in kubernetes secrets.

### Rotate credentials

The generated credentials can be rotated by specifying its quarkssecret's name in a configmap. The configmap must have the following label:

```
quarks.cloudfoundry.org/secret-rotation
```

### Approve Certificates

In the case, where a certificate is generated, the QuarksSecret ensures that a certificate signing request is generated and is approved by the Kubernetes API server.

## `QuarksSecret` Examples

See https://github.com/cloudfoundry-incubator/quarks-secret/tree/master/docs/examples
