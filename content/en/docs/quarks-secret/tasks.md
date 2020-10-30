---
title: "Tasks"
linkTitle: "Tasks"
weight: 30
description: >
  Working with QuarksSecret
---


## User Provided Secrets

To skip generation of secrets and provide custom values, create the secret first.

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/user-provided-secret.yaml" lang="yaml">}}

Quarks Secret will skip existing secrets of the same name.
Generated secrets have the `quarks.cloudfoundry.org/secret-kind=generated` label.

## Rotation Config

The generated secret values can be updated by creating a special 'rotation config' config map.
The configmap must have the label `quarks.cloudfoundry.org/secret-rotation`.

The rotation config specifies a list of QuarksSecret names:

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/rotate.yaml" lang="yaml" options="hl_lines=9">}}

After creation of the config map, the generated secrets of the listed QuarksSecrets will be updated. Updates to the rotation config are ignored, it has to be deleted and created again for another rotation run.

If a secret is missing the `quarks.cloudfoundry.org/secret-kind=generated` it will not be changed.

## Copy Secrets Into Another Namespace

The Quarks Secret operator can also generate copies in multiple namespaces while generating secrets.

For example, while generating passwords:

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/copy.yaml" lang="yaml" >}}

A list of copying targets can be specified with the `copies` key:

```yaml
  copies:
  - name: copied-secret
    namespace: namespace1
```

As a safeguard against incidential updates, each indicated destination needs to have a `QuarksSecret` of the `copy` type in the following form:

{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/copy-qsecret-destination.yaml" lang="yaml" >}}


The example copies the generated `gen-secret` secret content into `copied-secret`  inside the `COPYNAMESPACE` namespace.

## Templated Config Secret Generation

This feature is particularly useful for projects which requires their configuration in a specific format and also which require their entire config to be specified in one secret.

For example, 
{{<githubembed repo="cloudfoundry-incubator/quarks-secret" file="docs/examples/templated-config.yaml" lang="yaml" >}}

here we have a simple key value pair format of a configuration in the `templates` key. The `values` consists of the secret names from where the values needs to be fetched. 

The above example when run, will create the following `templated-secret` configuration secret.

```
apiVersion: v1
kind: Secret
metadata:
  name: templated-secret
type: Opaque
Data:
  foo: GSA7Kndi4BzUQjL3cSHv0CRVsNWGBXgibzpzxKvZAHR2sdMLIBJ6jONBcmSCDHp8
```

