# Updates to Quarks Operators

Expections for upgrading the operator

* migration scripts (helm hooks) run in a job
* create events for all watched resources are expected
* new services might start up (e.g. dns)


# Updates to the Workloads

* tries to update only what's necessary
* workloads that have watched resources changed
* doesn't update for image only without label workaround

## How to add a Migration

* add script to `deploy/helm/hooks` folder
* add RBAC permissions to `deploy/helm/quarks/templates/role-hooks.yml`

# Instance Group Updates

IG are Quarks Statefulset. Quarks Statefulset (qsts) will create one statefulset per AZ.

In case of an upgrade to an instance group, the rolling update strategy of the statefulset will restart the last pod first.
If that pod is ready, the remaining pods will be restarted, keeping their original volumes, in the new statefulset.

For the duration of the upgrade, multiple versions of the statefulset, distinguishable by the controller revision hash, exist.

## Immutable Fields

Several fields in a statefulset are immutable.

For example, when resizing disks, the qsts will be updated for manifest changes. The sts will not change.
When changing the pods, the sts will not reflect those changes.

To update the sts, it has to be deleted and recreated with the same pod selector.

Quarks statefulset does not support updating, by deleting the sts and recreating it.
