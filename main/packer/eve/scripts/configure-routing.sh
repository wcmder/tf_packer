#!/usr/bin/env bash
set -euo pipefail

# Run after configure-pnet1.sh during image provisioning.
ip -4 address show dev pnet1 | grep -q 'inet 172.16.1.1/24' || {
  echo 'Configure pnet1 as 172.16.1.1/24 before provisioning routing.' >&2
  exit 1
}

cat > /etc/sysctl.d/99-eve-routing.conf <<'EOF'
net.ipv4.ip_forward=1
EOF
sysctl -p /etc/sysctl.d/99-eve-routing.conf
