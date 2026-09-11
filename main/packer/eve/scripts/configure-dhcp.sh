#!/usr/bin/env bash
set -euo pipefail

ip -4 address show dev pnet1 | grep -q 'inet 172.16.1.1/24' || {
  echo 'Configure pnet1 as 172.16.1.1/24 before provisioning DHCP.' >&2
  exit 1
}

# Install the binary without enabling a general-purpose dnsmasq service.
apt-get update
apt-get install --yes dnsmasq-base
install -d -m 0755 /etc/eve-dhcp

cat > /etc/eve-dhcp/pnet1.conf <<'EOF'
port=0
interface=pnet1
bind-dynamic
dhcp-range=172.16.1.100,172.16.1.199,255.255.255.0,infinite
dhcp-option=option:router,172.16.1.1
# Management access uses IP addresses; do not advertise a nonexistent DNS service.
dhcp-option=option:dns-server
dhcp-leasefile=/var/lib/eve-dhcp/pnet1.leases
log-dhcp
EOF

cat > /etc/systemd/system/eve-pnet1-dhcp.service <<'EOF'
[Unit]
Description=DHCP for EVE Cloud1 router management
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
StateDirectory=eve-dhcp
ExecStart=/usr/sbin/dnsmasq --keep-in-foreground --conf-file=/etc/eve-dhcp/pnet1.conf
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

dnsmasq --test --conf-file=/etc/eve-dhcp/pnet1.conf
systemctl daemon-reload
systemctl enable eve-pnet1-dhcp.service
systemctl restart eve-pnet1-dhcp.service
systemctl is-active --quiet eve-pnet1-dhcp.service
