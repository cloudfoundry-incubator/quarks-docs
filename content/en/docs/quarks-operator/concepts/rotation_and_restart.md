---
title: "Rotation and Restart"
linkTitle: "Rotation and Restart"
weight: 30
description: >
  Rotating a Certificate and restarting affected pods
---

## Setup

With a default Quarks Operator installation, that uses the 'staging' namespace.
First, create the certificate that will be used by the statefulset.

{{<code file="/content/en/docs/quarks-operator/examples/qsec-certificate.yaml" lang="yaml">}}

This statefulset starts [quarks-gora](https://github.com/cloudfoundry-incubator/quarks-gora) directly from the docker image, not from the BOSH release.

{{<code file="/content/en/docs/quarks-operator/examples/statefulset.yaml" lang="yaml">}}

Note that the statefulset has the `quarks.cloudfoundry.org/restart-on-update: "true"` annotation, to opt in to restarts.

## Rotation

By creating the [rotation config](../../quarks-secret/tasks/#rotation-config), the secret gets updated.

{{<code file="/content/en/docs/quarks-operator/examples/rotate.yaml" lang="yaml">}}

The quarks-restart controller detects the change and restarts the statefulsets of annotated pods.

You can run `kubectl run -it --rm --restart=Never curl --image=curlimages/curl sh` to spawn a shell inside KinD and access gora at `https://gora.staging`.

Some connections might hang and fail as the statefulset restarts and the pod IPs change.
