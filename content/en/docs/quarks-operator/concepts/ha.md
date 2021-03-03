---
title: "High Availability"
linkTitle: "ha"
weight: 90
description: >
  How High-Availability is implemented
---

# Instance Count

For BOSH instance groups, one can increase the instance count, which results in a k8s statefulset with that number set as replica count.
There is no guarantee that pod replicas in a statefulset will be started on different Kubernetes nodes, but affinity can be used to control pod placement.

# Multi AZ

Even more redundancy can be achieved by using multiple availability zones, as described in the [qsts controller docs](../../../quarks-statefulset/development#az-support).
In short, Multi AZ uses labeled nodes and spawns `replica count` pods in each AZ. Quarks creates a separate statefulset in each AZ.

In order for things to work correctly across versions and AZs, we need [ClusterIP `Services`](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#using-stable-network-identities) that select for Instance Group `Pods`.

Services:
```text
nats-z0-0
  selects pod nats-z0-0
nats-z0-1
  selects pod nats-z0-1
nats-z1-0
  selects pod nats-z1-0
nats-z1-1
  selects pod nats-z1-1
```
(from [Services And DNS Addresses](rendering_templates.md#services-and-dns-addresses) )

The services select pods via the pod-ordinal label.

Service selector example for "nats-0" service:
```yaml
selector:
  quarks.cloudfoundry.org/az-index: "0"
  quarks.cloudfoundry.org/deployment-name: kubecf
  quarks.cloudfoundry.org/instance-group-name: nats
  quarks.cloudfoundry.org/pod-ordinal: "0"
```

Quarks also generates an additional `nats' service for all of them.

## Pod Ordinal

When the pod is created, the Quarks statefulset pod mutator sets the `pod-ordinal` label to the [suffix from the pod name](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#using-stable-network-identities) from the pod's name.

The pod ordinal is later passed to BOSH job template rendering.

It's always 0 for errands.

A new statefulset in another AZ, will start again with pod-ordinal 0.


## Zone Index (az-index)

Each statefulset belongs to one AZ.

The Quarks statefulset (qsts) reconciler sets the `az-index` label, when creating the statefulsets.

It's 0 if the instance group does not have any AZs. Otherwise it just starts at zero and increments by one.

*Example*: Given the zones "z1" and "z2", Quarks will use the zone indexes "z0" and "z1" in resource names. The `az-index` labels will contain "0" and "1".

While the `az-index` pod label starts at 0, the `AZ_INDEX` env var on containers starts at 1.

## Replicas

The replica count is initially set it the `Instances` number from the instance group manifest.

QuarksStatefulSet reconciler might also overwrite the replica env count if `injectReplicaEnv` is true.

The `template-render` sub-command, will increase the relplica count to match the given pod-ordinal, if necessary.


# BOSH Job Template Rendering

This is how BOSH manifest variables are translated into job template rendering variables:

* Quarks operator builds ig manifests, using the `instance-group` sub-command
* Quarks operator create resources, like qsts from manifest
* Quarks statefulset manages statefulsets and adapts values when reconciling
* sts starts pods
* quarks sts pod mutator adapts values
* pod labels are mounted as env variables
* environment variables are used as args when calling the `template-render` sub-command in an init container

Both, the `instance-group` and the `template-render` sub-command need to build an array of all possible [BOSH job `spec` properties](https://bosh.io/docs/jobs/#properties) for every instance of the instance group.

Template rendering computes a 'spec index', from az-index and pod-ordinal, to find the matching spec.

## spec.bootstrap

> True if this instance is the first instance of its group.
([BOSH jobs](https://bosh.io/docs/jobs/))

The pod that starts first in a statefulset must have the bootstrap flag. It's used to initialize databases and such.

After the initial deployment, the last pod has the bootstrap flag. If the pod is restarted, the bootstrap flag stays the same, since the pod ordinal doesn't change in a statefulset.

Bootstrap is only run once, regardless the number of AZs.

## spec.index

> Instance index. Use spec.bootstrap to determine the first instead of checking whether the index is 0. Additionally, there is no guarantee that instances will be numbered consecutively, so that there are no gaps between different indices.
([BOSH jobs](https://bosh.io/docs/jobs/))

In the past using the replica count lead to unnecessary restarts, so a very large value is used instead:

    // azindex podOrdinal  specIndex
    //    0       0          0
    //    0       1          1
    //    1       0          0
    //    1       1          1
    //    2       0          10000
    //    2       1          10001

## spec.address

> Default network address (IPv4, IPv6 or DNS record) for the instance
([BOSH jobs](https://bosh.io/docs/jobs/))

In Quarks the spec.address should always be the advertisable address of the pod.

The address is the name of the pod, which already includes the pod-ordinal and optionally the az-index.

Some BOSH jobs use this to find their local interface, like the NATS release.
This works since spec.address matches the hostname entry in /etc/hosts and gives the local ip address.

# Other Usage of Pod Ordinal

It's also available to

* bosh-pre-start Init Containers
* bpm-pre-start Init Containers
* bpm Process Container

# History

## Quarks 7.2

Removes startup-ordinal and just uses pod-ordinal.

## Quarks 7.1

Introduces startup-ordinal to fix bugs from 6.1. Keeps workaround.

* [Bootstrap using new startup ordinal](https://github.com/cloudfoundry-incubator/quarks-operator/issues/1182)
* [Keep startup ordinal when pods restart](https://github.com/cloudfoundry-incubator/quarks-operator/issues/1271)

Open problems with updating kubecf
* nats release binding to spec.address
* diego-cell rep-rep, too?

## Quarks 6.1

Had a [workaround for HA](https://github.com/cloudfoundry-incubator/quarks-operator/commit/89a56300d40a0da74719c9d80c1e7e27616fc68a).
