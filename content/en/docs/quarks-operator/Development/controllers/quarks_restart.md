---
title: "Quarks restart"
linkTitle: "Quarks restart"
weight: 4
description: >
  The QuarksRestart controller is responsible for restarting kubernetes resources such as `StatefulSet` and `Deployment`.
---

## Description

The QuarksRestart controller is responsible for restarting kubernetes resources such as `StatefulSet` and `Deployment`. They are restarted whenever a secret referenced by these resources gets updated.

This feature also enables updating entangled pods whenever the link secrets get updated.

#### Watches in Quarks Restart Controller

- `Secret`: Restart pods that have the annotation `quarks.cloudfoundry.org/restart-on-update`

#### Reconciliation in Quarks Restart Controller

- adds restart annotation `quarks.cloudfoundry.org/restart` to `StatefulSet` or `Deployment` as appropriate.


## Examples

See https://github.com/cloudfoundry-incubator/quarks-operator/tree/master/docs/examples/quarks-restart
