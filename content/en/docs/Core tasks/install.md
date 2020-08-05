---
title: "Install"
linkTitle: "Install quarks-operator"
weight: 1
description: >
  Installation of Quarks-operator in your Kubernetes cluster with helm
---

The `quarks-operator` can be installed via `helm`. You can use our [helm repository](https://cloudfoundry-incubator.github.io/quarks-helm/).

See the [releases page](https://github.com/cloudfoundry-incubator/cf-operator/releases) for up-to-date instructions on how to install the operator.

For more information about the `quarks-operator` helm chart and how to configure it, please refer to the helm repository [README.md](https://github.com/cloudfoundry-incubator/quarks-operator/tree/master/deploy/helm/cf-operator). A short summary of the installation steps is presented below.

## Prerequisites

- Kubernetes cluster
- helm
- kubectl


## Installation

Add the quarks repository to helm if you haven't already:

```bash
helm repo add quarks https://cloudfoundry-incubator.github.io/quarks-helm/
```

The simplest way to install the operator, is by using the default values:

```bash
helm install cf-operator quarks/cf-operator --namespace cf-operator
```

The operator will watch for BOSH deployments in separate namespaces, not the one it has been deployed to. By default, it creates a namespace `staging` and starts watching it.

A complete list of the chart settings is available [here](https://hub.helm.sh/charts/quarks/cf-operator).

### Multiple namespaces

The quarks-operator watches namespaces labeled with `quarks.cloudfoundry.org/monitored=ID`. The `ID` has to be specified with helm settings during install (`--set "global.monitoredID=ID"`).
The helm value setting `global.singleNamespace.name=` allows to automatically create a namespace which is being watched by the quarks-operator.

For example, to watch to a different namespace with a specific ID:

```bash
helm install relname1 quarks/cf-operator \
  --namespace namespace1
  --set "global.singleNamespace.name=staging1" \
  --set "global.monitoredID=id1" \
  --set "quarks-job.persistOutputClusterRole.name=clusterrole1"
```

### Using multiple namespaces with one operator

The cluster role can be reused between namespaces. The service account (and role binding) should be different for each namespace.

```bash
helm install relname1 quarks/cf-operator \
  --set "global.singleNamespace.create=false"
```
Manually create before running helm install, for each namespace:

- a namespace "staging1" with the following labels (note: "cfo" and "qjob-persist-output" are the defaults from values.yaml):
```
        quarks.cloudfoundry.org/monitored: "cfo"
        quarks.cloudfoundry.org/qjob-service-account: qjob-persist-output
```
- a service account named "qjob-persist-output"
- a role binding from the existing cluster role "qjob-persist-output" to "qjob-persist-output" service account in namespace "staging1"


For more options look at the README for the chart

```bash
helm show readme quarks/cf-operator
```

## What next?

With a running `quarks-operator` pod, you can try one of the files (see [boshdeployment-with-custom-variable.yaml](https://raw.githubusercontent.com/cloudfoundry-incubator/quarks-operator/master/docs/examples/bosh-deployment/boshdeployment-with-custom-variable.yaml) ), as follows (if you installed it with default values):

```bash
kubectl -n staging apply -f https://raw.githubusercontent.com/cloudfoundry-incubator/quarks-operator/master/docs/examples/bosh-deployment/boshdeployment-with-custom-variable.yaml
```

The above will spawn two pods in your `cf-operator` namespace (which needs to be created upfront), running the BOSH nats release.

You can access the `quarks-operator` logs by following the operator pod's output:

```bash
kubectl logs -f -n cf-operator cf-operator
```

Or look at the k8s event log:

```bash
kubectl get events -n cf-operator --watch
```

## Modifying the deployment

The main input to the operator is the `BOSH deployment` custom resource and the according manifest config map or secret. Changes to the `Spec` or `Data` fields of either of those will trigger the operator to recalculate the desired state and apply the required changes from the current state.

Besides that there are more things the user can change which will trigger an update of the deployment:

* `ops files` can be added or removed from the `BOSH deployment`. Existing `ops file` config maps and secrets can be modified
* generated secrets for [explicit variables](https://github.com/cloudfoundry-incubator/cf-operator/blob/master/docs/from_bosh_to_kube.md#variables-to-quarks-secrets) can be modified
* secrets for [implicit variables](https://github.com/cloudfoundry-incubator/cf-operator/blob/master/docs/from_bosh_to_kube.md#manual-implicit-variables) have to be created by the user beforehand anyway, but can also be changed after the initial deployment
