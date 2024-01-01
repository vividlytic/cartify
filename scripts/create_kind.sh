#!/bin/bash

cd `dirname $0`/../

echo "Creating kind cluster"
kind create cluster --config common/kind/kind-config.yaml
echo "--"

echo "Clusters"
kind get clusters
echo "--"

echo "Cluster Info"
kubectl cluster-info
