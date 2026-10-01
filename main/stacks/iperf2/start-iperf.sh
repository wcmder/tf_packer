#!/bin/sh
set -eu

# The gallery image supplies iPerf 3; fail clearly if an older image was used.
if [ ! -x /usr/bin/iperf3 ]; then
  echo 'Missing /usr/bin/iperf3: rebuild and deploy the iPerf gallery image with iPerf 3.' >&2
  exit 1
fi

# Stop the service installed by earlier versions of this extension, if present.
if [ -f /etc/systemd/system/iperf.service ]; then
  systemctl disable --now iperf.service
fi

cat > /etc/systemd/system/iperf3.service <<'UNIT'
[Unit]
Description=iPerf 3 server
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
DynamicUser=yes
ExecStart=/usr/bin/iperf3 -s -p 5201
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable iperf3.service
systemctl restart iperf3.service
systemctl is-active --quiet iperf3.service
