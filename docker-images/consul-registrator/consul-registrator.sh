#!/bin/sh

export EC2_INSTANCE_IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

exec /bin/registrator -ip $EC2_INSTANCE_IP_ADDRESS -retry-attempts -1 consul://$EC2_INSTANCE_IP_ADDRESS:8500
