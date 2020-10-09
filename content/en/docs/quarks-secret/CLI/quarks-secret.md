---
title: "quarks-secret"
linkTitle: "quarks-secret"
weight: 1
---
## quarks-secret

quarks-secret starts the operator

### Synopsis

quarks-secret starts the operator

```
quarks-secret [flags]
```

### Options

```
      --apply-crd                    (APPLY_CRD) If true, apply CRDs on start (default true)
      --ctx-timeout int              (CTX_TIMEOUT) context timeout for each k8s API request in seconds (default 300)
  -h, --help                         help for quarks-secret
  -c, --kubeconfig string            (KUBECONFIG) Path to a kubeconfig, not required in-cluster
  -l, --log-level string             (LOG_LEVEL) Only print log messages from this level onward (trace,debug,info,warn) (default "debug")
      --max-workers int              (MAX_WORKERS) Maximum number of workers concurrently running the controller (default 1)
      --meltdown-duration int        (MELTDOWN_DURATION) Duration (in seconds) of the meltdown period, in which we postpone further reconciles for the same resource (default 60)
      --meltdown-requeue-after int   (MELTDOWN_REQUEUE_AFTER) Duration (in seconds) for which we delay the requeuing of the reconcile (default 30)
      --monitored-id string          (MONITORED_ID) only monitor namespaces with this id in their namespace label (default "default")
```

### SEE ALSO

* [quarks-secret version](../quarks-secret_version)	 - Print the version number

###### Auto generated by spf13/cobra on 25-Aug-2020