#!/bin/bash

echo "Starting GKE node startup script for version logging..." | tee -a /var/log/node_versions.log

# Log kubelet version
if command -v kubelet &> /dev/null; then
    KUBELET_VERSION=$(kubelet --version 2>&1)
    echo "Kubelet Version: $KUBELET_VERSION" | tee -a /var/log/node_versions.log
else
    echo "Kubelet command not found." | tee -a /var/log/node_versions.log
fi

# Log containerd version
if command -v containerd &> /dev/null; then
    CONTAINERD_VERSION=$(containerd --version 2>&1)
    echo "Containerd Version: $CONTAINERD_VERSION" | tee -a /var/log/node_versions.log
elif command -v ctr &> /dev/null; then
    CONTAINERD_VERSION=$(ctr version 2>&1 | grep "client version" | awk '{print $NF}')
    echo "Containerd (via ctr) Version: $CONTAINERD_VERSION" | tee -a /var/log/node_versions.log
else
    echo "Containerd command not found." | tee -a /var/log/node_versions.log
fi

# Log runc version (if available)
if command -v runc &> /dev/null; then
    RUNC_VERSION=$(runc --version 2>&1)
    echo "Runc Version: $RUNC_VERSION" | tee -a /var/log/node_versions.log
else
    echo "Runc command not found." | tee -a /var/log/node_versions.log
fi

echo "GKE node startup script for version logging completed." | tee -a /var/log/node_versions.log
