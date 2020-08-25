
---
title: "Documentation"
linkTitle: "Documentation"
weight: 20
menu:
  main:
    weight: 20
---

![Quarks logo](cf-operator-logo.png)

* Incubation Proposal: [Containerizing Cloud Foundry](https://docs.google.com/document/d/1_IvFf-cCR4_Hxg-L7Z_R51EKhZfBqlprrs5NgC2iO2w/edit#heading=h.lybtsdyh8res)
* Backlog: [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/2192232)
* Docker: https://hub.docker.com/r/cfcontainerization/cf-operator/tags

[Project Quarks](https://www.cloudfoundry.org/project-quarks/) is an incubating effort within the Cloud Foundry Foundation to integrate Cloud Foundry and Kubernetes.
It packages the Cloud Foundry Application Runtime as containers instead of virtual machines, enabling easy deployment to Kubernetes.

The resulting containerized CFAR provides an identical developer experience to that of BOSH-managed Cloud Foundry installations, requires less infrastructure capacity and delivers an operational experience that is familiar to Kubernetes operators.

Quarks is split into several components, which work together to run Cloud Foundry, but can also be used separately.
