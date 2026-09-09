#!/usr/bin/env bash
set -euo pipefail

# Cloud1 is an internal management network; never attach the Azure NIC here.
# Replace EVE's existing pnet1 stanza without restarting management networking.
python3 - <<'PY'
from pathlib import Path
import re

path = Path('/etc/network/interfaces')
text = path.read_text()
backup = path.with_name('interfaces.before-pnet1')
if not backup.exists():
    backup.write_text(text)
lines = []
skip = False
for line in text.splitlines(keepends=True):
    if re.match(r'^\s*iface\s+pnet1\s+', line):
        skip = True
        continue
    if re.match(r'^\s*(auto|allow-\S+|iface|mapping|source|source-directory)\s+', line):
        skip = False
    if skip:
        continue
    if re.match(r'^\s*(auto|allow-\S+)\s+', line):
        tokens = line.split('#', 1)[0].split()
        if 'pnet1' in tokens[1:]:
            tokens.remove('pnet1')
            if len(tokens) > 1:
                lines.append(' '.join(tokens) + '\n')
            continue
    lines.append(line)
path.write_text(''.join(lines).rstrip() + '''

auto pnet1
iface pnet1 inet static
    address 172.16.1.1
    netmask 255.255.255.0
    bridge_ports none
    bridge_stp off
    bridge_fd 0
''')
PY

if ! ip link show dev pnet1 >/dev/null 2>&1; then
  ip link add name pnet1 type bridge
fi
ip address replace 172.16.1.1/24 dev pnet1
ip link set dev pnet1 up
