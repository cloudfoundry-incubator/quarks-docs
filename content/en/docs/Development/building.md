---
title: "Build"
linkTitle: "Build quarks-operator"
weight: 2
description: >
  Build Quarks-operator from source
---

The following steps layout the process of building `quarks-operator` (formerly `cf-operator`) from source and how to install it in your Kubernetes cluster.

{{% alert title="Note" color="info" %}}
The Quarks Operator was previously known as `cf-operator`. We are renaming the `cf-operator` project into `quarks-operator`. Docker images and other sections might not be migrated yet, we are sorry for the confusion.
{{% /alert %}}

## Build it from source

Follow this steps to build a proper docker image and generate a deployable helm chart:

1. Checkout the latest stable release / or run it from develop branch

    ```bash
    git checkout v0.3.0
    ```

2. Download the shared tools

    ```bash
    bin/tools
    ```

2. Build the quarks-operator binary, this will be embedded later on the docker image

    ```bash
    bin/build
    ```

3. Build the docker image

    When running in minikube, please run: `eval $(minikube docker-env)`, to build the image
    directly on minikube docker.

    ```bash
    bin/build-image
    ```

    _**Note**_: This will automatically generate a docker image tag based on your current commit, tag and SHA.

4. Generated helm charts with a proper docker image tag, org and repository

    ```bash
    bin/build-helm
    ```

    _**Note**_: This will generate a new directory under the base dir, named `helm/`

5. Install the helm chart(apply Kubernetes Custom Resources)

    ```bash
    helm install cf-operator-test helm/quarks-operator
    ```

    _**Note**_: The quarks-operator will be available under the namespace set in the context, usually `default`, running as a pod.
