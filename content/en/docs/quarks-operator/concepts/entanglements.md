---
title: "Entanglements"
linkTitle: "Entanglements"
weight: 30
description: >
  Quarks Links can provide secrets to pods outside the deployment and can consume existing secrets
---

Also known as "Quarks Links" - they provide a way to share/discover information between BOSH and Kube Native components.

## Using k8s Native Values in BOSH Deployments

{{% alert title="Note" color="info" %}}
Native -> BOSH
{{% /alert %}}

In this case, the native component is a provider, and the BOSH component is a consumer.

We construct link information from the native resources like this:

| BOSH Link           | Native  | Description                                                                                              |
| ------------------- | ------- | -------------------------------------------------------------------------------------------------------- |
| address             | Service | DNS address of a k8s *service* annotated  `quarks.cloudfoundry.org/provides = LINK_NAME`                 |
| azs                 | N/A     | not supported                                                                                            |
| properties          |         | properties retrieved from a *secret* annotated `quarks.cloudfoundry.org/provides = LINK_NAME`            |
| instances.name      | Pod     | name of *pod* selected by the k8s *service* that's annotated `quarks.cloudfoundry.org/provides = LINK_NAME` |
| instances.id        | Pod     | *pod* uid                                                                                                |
| instances.index     | Pod     | set to a value 0-(pod replica count)                                                                     |
| instances.az        | N/A     | not supported                                                                                            |
| instances.address   | Pod     | ip of *pod*                                                                                              |
| instances.bootstrap | Pod     | set to true if index == 0                                                                                |

> If multiple secrets or services are found with the same link information, the operator should error

### Example

When a job consumes a link, it will need a section like this in the in its job spec (`job.MF`), e.g. the nats release:

```yaml
consumes:
- name: nats
  type: nats
```

The deployment manifests needs to explicitly consume the link:

{{<githubembed repo="cloudfoundry-incubator/quarks-operator" file="docs/examples/quarks-link/native-to-bosh/boshdeployment.yaml" lang="yaml"  options="hl_lines=6">}}

To fulfill the link we need to create a k8s secret, like this:

{{<githubembed repo="cloudfoundry-incubator/quarks-operator" file="docs/examples/quarks-link/native-to-bosh/link-secret.yaml" lang="yaml"  options="hl_lines=6">}}

The [quarks-gora release](https://github.com/cloudfoundry-incubator/quarks-gora-release/blob/master/jobs/quarks-gora/templates/bpm.yml.erb) can then use the links in its eruby templates:

```eruby
"<%= p("quarks-gora.ssl") %>"
```

Furthermore, if there is a matching k8s service, it will be used in the link:

{{<githubembed repo="cloudfoundry-incubator/quarks-operator" file="docs/examples/quarks-link/native-to-bosh/link-service.yaml" lang="yaml"  options="hl_lines=6">}}

Using this service, I should be able to use `link("quarks-gora").address`, and I should get a value of `testservice`.

This service selects for `Pods` that have the label `app: linkpod`. The `instances` array should be populated using information from these pods.

If the secret is changed, consumers of the link are automatically restarted.

If the service is changed, or the list of pods selected by the service is changed, consumers of the link are automatically restarted.

## Using BOSH Variables in k8s Pods

{{% alert title="Note" color="info" %}}
BOSH -> Native
{{% /alert %}}

In this case, the BOSH component is a provider, and the native component is a consumer.
The native component is a pod, which might belong to a deployment or statefulset.

The operator creates link secrets for all providers in a BOSH deployment. Each secret contains a flattened map with the provided properties:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: link-nats-nats
  labels:
    quarks.cloudfoundry.org/container-name=nats
    quarks.cloudfoundry.org/deployment-name=nats-deployment
    quarks.cloudfoundry.org/entanglement=true
    quarks.cloudfoundry.org/remote-id=nats
data:
  nats.password: YXBwYXJlbnRseSwgeW91Cg==
  nats.port: aGF2ZSB0b28K
  nats.user: bXVjaCB0aW1lCg==
```

If a pod is annotated with the following:

```yaml
quarks.cloudfoundry.org/consumes: '[{"name":"nats","type":"nats"}]'
quarks.cloudfoundry.org/deployment: nats-deployment
quarks.cloudfoundry.org/restart-on-update: "true"
```

The operator will mutate the pod to:

- mount the link secrets as `/quarks/link/DEPLOYMENT/<type>-<name>/<key>`
- add an environment variable for each key in the secret data mapping: `LINK_<key>`

The `<name>` and `<type>` are the respective link type and name. For example, the nats release uses `nats` for both the name and the type of the link. The `<key>` describes the BOSH property, flattened (dot-style), for example `nats.password`. The key name is modified to be upper case and without dots in the context of an environment variable, therefore `nats.password` becomes `LINK_NATS_PASSWORD` in the container.

If link information changes and the pod has the 'restart-on-update' annotation, the operator will trigger an update (restart) of the deployment or statefulset owning the pod.

### Example

The following BOSH deployment, will create secrets for all links.

{{<githubembed repo="cloudfoundry-incubator/quarks-operator" file="docs/examples/quarks-link/boshdeployment.yaml" lang="yaml"  options="hl_lines=6">}}


The k8s deployment looks like this:

{{<githubembed repo="cloudfoundry-incubator/quarks-operator" file="docs/examples/quarks-link/entangled-dpl.yaml" lang="yaml"  options="hl_lines=6">}}

The nats release has the corresponding [`provides:` section](https://github.com/cloudfoundry/nats-release/blob/ed4bda59f835ce83eec2a129e8d3a25ad7405497/jobs/nats/spec#L18-L27).
