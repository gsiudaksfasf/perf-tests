#!/bin/bash

# ==============================================================================
# WARNING: This script sets maximum log verbosity and is intended for deep
# debugging only. It will generate a very high volume of logs, which can
# impact node performance and significantly increase logging costs.
# ==============================================================================

set -e # Exit immediately if a command exits with a non-zero status.

# --- Configure Kubelet for Maximum Verbosity ---

KUBELET_CONFIG_FILE="/etc/systemd/system/kubelet.service.d/10-kubeadm.conf"

if [ -f "$KUBELET_CONFIG_FILE" ]; then
    echo "Configuring kubelet verbosity..."
    # Remove any existing verbosity flag to prevent conflicts
    sed -i "s|--v=[0-9]*||g" "$KUBELET_CONFIG_FILE"
    # Append the highest verbosity level (v=9) to the ExecStart line
    sed -i "/^ExecStart=/ s|\$| --v=9|" "$KUBELET_CONFIG_FILE"
    echo "Kubelet verbosity set to 9."
else
    echo "Kubelet config file not found at $KUBELET_CONFIG_FILE. Skipping."
fi

# --- Configure Containerd for Maximum Verbosity ---

CONTAINERD_CONFIG_FILE="/etc/containerd/config.toml"

echo "Configuring containerd verbosity..."
# Create directory if it doesn't exist
mkdir -p /etc/containerd

# Use a here-document to create a minimal but correct config with 'trace' level
cat > "$CONTAINERD_CONFIG_FILE" <<EOF
version = 2
# Setting the highest 'trace' level for containerd debug logs
[debug]
  level = "trace"
EOF
echo "Containerd log level set to 'trace'."


# --- Apply Changes ---

echo "Reloading systemd and restarting services..."
systemctl daemon-reload
systemctl restart containerd
systemctl restart kubelet

echo "Successfully applied maximum verbosity settings."
