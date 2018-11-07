#!/bin/sh

export EC2_INSTANCE_IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat << EOF > /etc/linkerd/linkerd.yaml
admin:
  ip: 0.0.0.0
  port: 9990

namers:
- kind: io.l5d.consul
  host: $EC2_INSTANCE_IP_ADDRESS
  port: 8500

telemetry:
- kind: io.l5d.prometheus
- kind: io.l5d.recentRequests
  sampleRate: 0.25

usage:
  orgId: linkerd-examples-ecs # TODO where is is used?

routers:
- protocol: http
  label: outgoing
  servers:
  - ip: 0.0.0.0
    port: 4140
  interpreter:
    kind: default
    transformers:
    # tranform all outgoing requests to deliver to incoming linkerd port 4141
    - kind: io.l5d.port
      port: 4141
  dtab: |
    /svc => /#/io.l5d.consul/dc1;
- protocol: http
  label: incoming
  servers:
  - ip: 0.0.0.0
    port: 4141
  interpreter:
    kind: default
    transformers:
    # filter instances to only include those on this host
    - kind: io.l5d.specificHost
      host: $EC2_INSTANCE_IP_ADDRESS
  dtab: |
    /svc => /#/io.l5d.consul/dc1;
EOF

/io.buoyant/linkerd/1.3.6/bundle-exec -log.level=DEBUG /etc/linkerd/linkerd.yaml
