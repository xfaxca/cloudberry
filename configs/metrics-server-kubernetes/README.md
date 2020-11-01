## Metrics API / Server
Github: https://github.com/kubernetes-sigs/metrics-server

Quick install command: `kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/{VERSION}/components.yaml`

Note, if experiencing an error like `[unable to fully scrape metrics from source {pod/node name}. no metrics known for {pod/node name}]`, try adding the following to the deployment:

```yaml
command:
  - /metrics-server
  - --v=2
  - --kubelet-preferred-address-types=InternalIP
  - --kubelet-insecure-tls=true
```

