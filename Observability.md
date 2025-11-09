Observability & Operations (Selar Cloud Platform)

When it comes to running infrastructure on EKS, my goal is always to make it observable from day one, not as an afterthought. I’d approach observability in three layers — metrics, logs, and traces — all unified with OpenTelemetry as the foundation.

[A] Metrics and Traces — OpenTelemetry + Prometheus + Grafana

I would instrument the application with the OpenTelemetry SDK (depending on the language — Python) to automatically capture:
(1) Request latency
(2) Error rates
(3) Resource usage (CPU, memory)
(4) gRPC/HTTP spans for distributed tracing

All telemetry data would be exported to Prometheus for metrics, and Tempo or New Relic for distributed traces.

In practice, I would deploy an OpenTelemetry Collector in the cluster using Helm. It would receive data from all services and export it to Prometheus (for metrics) and a backend like New Relic or Grafana Cloud (for traces).

This way, I can visualize:
(1) Latency across services
(2) Database query performance
(3) Pod-level metrics
(4) End-to-end request flows


[B] Centralized Logging — Fluent Bit + CloudWatch / Loki

For logs, I’d run Fluent Bit as a DaemonSet in EKS.
It would collect:
(1) Application logs from stdout
(2) Kubernetes logs from /var/log/containers

Then route them to:

CloudWatch Logs for AWS-native analysis Or Grafana Loki if we want a full open-source stack

This gives visibility into both system-level and application-level events.


You meant be wondering Why Fluent Bit with CloudWatch (and not CloudWatch alone)
AWS CloudWatch Logs serves as the destination for most EKS logs — but CloudWatch by itself doesn’t collect logs directly from Kubernetes nodes or pods.
It’s only a storage and visualization service.

The missing piece is the log forwarder, and that’s where Fluent Bit comes in.
So what does Fluent Bit actually do?
Fluent Bit is a lightweight log processor and shipper that:

(1) Runs as a DaemonSet (one pod per node)
(2) Tails logs from /var/log/containers (so every pod’s stdout/stderr)
(3) Parses, filters, and enriches logs (adds metadata like namespace, pod, container)
(4) Then forwards them to a destination such as CloudWatch or Loki

AWS even maintains an official Fluent Bit image (amazon/aws-for-fluent-bit) optimized for EKS.
You might also ask can’t CloudWatch Agent do that?

So Technically yes but Fluent Bit is smaller, faster, and now the AWS-recommended solution for Kubernetes.It consumes less memory and CPU, supports filtering and parsing better, and integrates more cleanly with containers.
In fact, AWS’s EKS add-on for Container Insights uses Fluent Bit under the hood to send logs and metrics to CloudWatch.


[C] Alerts & Dashboards

With metrics in Prometheus and traces in Grafana, I would define a few key SLO-based alerts:

(1) High API latency
(2) Pod restarts or CrashLoopBackOff
(3) Increased error rates (5xx responses)
(4) High CPU/memory utilization

Alerts would be sent via PagerDuty or Slack, so incidents are visible immediately.
Dashboards in Grafana would show:

(1) Service health (per endpoint)
(2) Error trends over time
(3) Cluster resource utilization
(4) Request traces with latency breakdowns

[D] Incident Mitigation & Post-Incident Process

When an alert fires:
(1) I would start by checking Grafana dashboards or New Relic traces to identify if it’s a service-specific or infrastructure-level issue.
(2) If the issue is due to a recent deployment, the CI/CD system (GitHub Actions) has built-in rollback support via versioned ECR images — we can redeploy a previous stable tag.
(3) For infrastructure failures (e.g., node not ready, pod evictions), we’d rely on EKS autoscaling and self-healing.
(4) Once the incident is resolved, we’d document the root cause and preventive action in a postmortem report, and possibly automate the mitigation (e.g., add HPA or circuit breakers).