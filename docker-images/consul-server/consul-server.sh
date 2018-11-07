#!/bin/sh

export EC2_INSTANCE_IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
export EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

mkdir -p /opt/consul/data
mkdir -p /opt/consul/config

docker-entrypoint.sh agent -server -bootstrap-expect 1 -advertise $EC2_INSTANCE_IP_ADDRESS -client 0.0.0.0 -ui
