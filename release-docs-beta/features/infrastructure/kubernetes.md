# Kubernetes

> Clusters, nodes, workloads and pods from kube-state-metrics, with the agent in one kubectl apply.

**Monitor → Infrastructure → Kubernetes** shows each cluster: its nodes, namespaces,
workloads (Deployments, StatefulSets, DaemonSets) and pods, what is wrong with them, and
the pods' logs. It is built from:

| Data | Comes from | Gives |
|---|---|---|
| Objects | kube-state-metrics | Nodes and their conditions, pods and their phase, restarts, waiting and exit reasons, workloads and their ready pods, jobs |
| Usage | The kubelets' cAdvisor | CPU and memory of every pod and container |
| Machines | node_exporter | Each node also shows under Hosts ([Hosts and containers](README.md)) |
| Logs | Fluent Bit | Pod logs, with namespace, pod, container and service |

A cluster is a metrics source plus its `cluster` label, so nothing has to be registered:
it appears as soon as kube-state-metrics data arrives.

## Connecting a cluster

### The Pulsimo agent (one kubectl apply)

**Infrastructure → Add hosts → Kubernetes cluster** (or Connect → *A Kubernetes cluster*).

1. Type a name for the cluster, for example `prod-eu`. It becomes the `cluster` label on
   everything the agent sends.
2. **Prepare the manifest.** Pulsimo creates two sources, *prod-eu cluster* (metrics) and
   *prod-eu logs* (logs), and gives you `pulsimo-agent.yaml` with their tokens inside (shown
   only this once). **Download** it.
3. With a kubeconfig pointing at the cluster:

   ```bash
   kubectl apply -f pulsimo-agent.yaml
   ```

The checklist next to it updates every 5 seconds:

| Step | Done when |
|---|---|
| The agent connects | vmagent's first metrics arrive |
| Nodes and pods | kube-state-metrics reports them |
| CPU and memory | the kubelets' cAdvisor and node_exporter report |
| Pod logs | Fluent Bit's first lines arrive |

What the manifest creates, all in a `pulsimo` namespace:

| Object | Does | Resources |
|---|---|---|
| `pulsimo-kube-state-metrics` (Deployment, kube-state-metrics 2.13) | Reports what Kubernetes knows | 10m CPU, 64 Mi requested, 256 Mi limit |
| `pulsimo-node-exporter` (DaemonSet, node_exporter 1.8.2) | The nodes themselves, on every node | 10m, 32 Mi / 128 Mi |
| `pulsimo-vmagent` (Deployment, vmagent 1.106.1) | Scrapes kube-state-metrics, each kubelet's cAdvisor (through the API server) and node_exporter, keeps only the container metrics Pulsimo uses, pushes everything; keeps up to 1 GB while Pulsimo is unreachable | 50m, 128 Mi / 512 Mi |
| `pulsimo-fluent-bit` (DaemonSet) | Tails `/var/log/containers`, adds pod metadata, pushes the lines (the agent's own pods are skipped) | 20m, 32 Mi / 256 Mi |
| `pulsimo-agent` ServiceAccount, ClusterRole and binding | Read-only access to nodes, pods, services, endpoints, namespaces, workloads and jobs | |

Nothing is exposed outside the cluster; everything is pushed to Pulsimo. The address it
pushes to is `LOG_INGEST_PUBLIC_URL` ([Configuration](../../configuration/environment-variables.md)); when that is `localhost`, the screen
warns that pods can't reach it.

Preparing the same cluster again keeps its sources with new tokens: apply the new manifest
for the agent to keep sending.

To remove it:

```bash
kubectl delete namespace pulsimo
kubectl delete clusterrole,clusterrolebinding pulsimo-agent
```

then delete *prod-eu cluster* (Infrastructure → Connect) and *prod-eu logs* (Logs → Sources).

### A Prometheus you already run (kube-prometheus-stack, Alloy, vmagent)

Use **Connect Prometheus** ([Hosts and containers](README.md)) and add a `cluster` external label, so the
cluster gets its name (without it, it is named after the connection):

```yaml
prometheus:
  prometheusSpec:
    externalLabels:
      cluster: prod-eu
```

kube-prometheus-stack already runs kube-state-metrics, node_exporter and the kubelet
cAdvisor scrape, so the pages fill in completely. For the logs, add Pulsimo as an output of
your Fluent Bit, Promtail, Alloy or Vector ([Hosts and containers](README.md)).

## The clusters

Each cluster card shows whether it is **Healthy** or **Needs a look** (a node not ready,
failing pods, a degraded workload or an open alarm), ready nodes, running pods, failing
pods, CPU and memory used against what the nodes can give (allocatable), namespaces,
degraded workloads and open alarms. A cluster that stopped reporting shows **Silent** with
how long ago.

## A cluster

Pick 1 hour, 6 hours, 24 hours or 7 days for the charts.

**Cards**: nodes ready, pods running (and pending), pods failing, workloads degraded, CPU
and memory used. Click one to go to its tab.

**Overview**

- **What needs a look**, worst first:

  | Problem | Means |
  |---|---|
  | Node not ready / under pressure | The kubelet stopped reporting, or memory, disk or PID pressure |
  | Pod crash looping | CrashLoopBackOff |
  | Pod can't pull its image / can't start | ImagePullBackOff, ErrImagePull, CreateContainerConfigError… |
  | Pod killed: out of memory | Its last exit was OOMKilled, within the hour |
  | Pod keeps restarting | 3 restarts or more, the last one within the hour |
  | Pod stuck in Pending | Pending for more than 5 minutes |
  | Workload has no ready pods / N of M ready | Fewer ready pods than it asks for |
  | Job failed | Failed and never succeeded since |

  Click a pod problem for its panel, a workload problem for its page, a node problem for its
  host page.
- **CPU and memory by namespace** over time (the six busiest).
- **Namespaces**: workloads, pods running, failing pods, CPU and memory. Click one to see
  its pods.
- **Open alarms** of the cluster.

**Workloads**: every Deployment, StatefulSet and DaemonSet with its status (Healthy,
Updating, Degraded, Down, Scaled to zero), ready pods against desired, restarts, CPU and
memory. Filter by text, namespace, kind and *Needs a look*. Click one for its page.

**Pods**: every pod with its status, ready containers, restarts (and how many in the last
hour), CPU, memory against its limit, node and age. Filter by text, namespace, node and
Running / Pending / Failing.

**Nodes**: ready or not, cordoned, pressure conditions, roles, CPU and memory used against
allocatable, pods against the node's maximum, versions. A node with node_exporter opens its
host page.

## A workload

Ready pods, failing pods, restarts, CPU and memory (against the sum of the pods' limits),
then three charts side by side with the logs of all its pods:

- CPU of all its pods, with the limits;
- memory of all its pods, with the limits;
- ready pods and restarts over time, which shows rollouts and crash loops.

The pods of the workload are found by name (`api-7d9f8c6b5d-x2k4p` for a Deployment,
`db-0` for a StatefulSet), so pods replaced by a rollout stay in the charts. The **Pods**
table lists the current ones.

## A pod

Click any pod for its panel: status and last exit reason, ready containers, restarts, CPU,
memory and their limits and requests, age, IP; each container with its image, state,
restarts and usage; CPU and memory charts with the limit line; and the pod's logs.

## Built-in alarms

On by default, under **Alerting → Rules → Built in** ([Alarms and rules](../alarms.md)), with the source
**Infrastructure**:

| Rule | Fires when | Default | Closes by itself |
|---|---|---|---|
| **Kubernetes node not ready** | A node's Ready condition is false | for 2 min, critical | when the node is Ready again |
| **Pod crash looping** | Restarts in a short while, or CrashLoopBackOff | 3 in 15 min, critical at 10 | when it stops restarting, or is deleted |
| **Pod out of memory** | A container was OOMKilled | within 15 min, critical | after the window, or when the pod is deleted |
| **Pod not starting** | Pending too long, or can't pull its image or load its config | Pending over 10 min; either has to hold 5 min | when it starts, or is deleted |
| **Workload not fully available** | Fewer ready pods than desired (Deployment, StatefulSet, DaemonSet) | for 10 min; critical when none is ready | when all its pods are ready |

## Notes

- Kubernetes pods are not listed under **Containers** and don't raise the container alarms
  of [Hosts and containers](README.md); their own pages and alarms cover them.
- Pod and container names come from kube-state-metrics; CPU and memory from cAdvisor. A
  sender that drops `container_*` metrics shows pods without usage.
- Logs are matched by namespace and pod name, so they show whichever log source sent them.

---

← [Hosts and containers](README.md) · [Contents](../../README.md) · [Incidents and evidence](../incidents.md) →
