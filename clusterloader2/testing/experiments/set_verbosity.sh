#!/bin/bash
set -e

# Configure kubelet in one line
sed -i -E 's/ --v=[0-9]+//; /^ExecStart=/ s/$/ --v=9/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# Configure containerd
cat > /etc/containerd/config.toml <<EOF
version = 2
[debug]
  level = "trace"
EOF

# Apply all changes
systemctl daemon-reload
systemctl restart containerd kubelet
