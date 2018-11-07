#!/bin/sh

export EC2_INSTANCE_IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
export EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
export REGION=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F: '{print $4}')

mkdir -p /opt/consul/data
mkdir -p /opt/consul/config

## TODO consul-agent tag_value
cat << EOF > /opt/consul/config/consul-agent.json
{
  "advertise_addr": "$EC2_INSTANCE_IP_ADDRESS",
  "client_addr": "0.0.0.0",
  "node_name": "$EC2_INSTANCE_ID",
  "retry_join": ["provider=aws tag_key=Consul tag_value=consul-agent region=$REGION"]
}
EOF

docker-entrypoint.sh agent -ui -config-file /etc/consul/consul-agent.json -data-dir /consul/data