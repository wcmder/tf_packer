# Image changelog

Changes to the EVE-NG and iPerf Packer images and their build pipelines. Azure infrastructure and deployment-only settings, such as VPN peers and gateway routes, are documented in [README.md](README.md).

## Recording releases

Add changes under the applicable image's Unreleased section. After a successful gallery publication, move the shipped entries into a section named `<image> — <gallery-version> — <YYYY-MM-DD>` and record the source Git commit and Azure DevOps build ID or run link. Keep a new Unreleased section for subsequent changes. Release recording is manual.

The entries below summarize recent repository changes; their first published image versions have not been verified. Unreleased does not establish whether a change is already present in a deployed VM.

## EVE — Unreleased

### Added

- Persistent internal Cloud1 / `pnet1` management bridge at `172.16.1.1/24`, without an Azure NIC attached.
- Persistent IPv4 forwarding configured during imaging for routed access to nested router management interfaces.
- Dedicated `eve-pnet1-dhcp` service, serving `172.16.1.100–172.16.1.199` with a `/24` mask and gateway `172.16.1.1`. DNS service is disabled.
- Persistent DHCP lease storage at `/var/lib/eve-dhcp/pnet1.leases`.
- Pipeline preflight verification of the pinned EVE installer SHA-256 before starting the Packer VM build; verification also runs before installer execution inside the VM.

### Changed

- DHCP leases now use `infinite` instead of 12 hours.
- Bridge, DHCP, and host routing setup run during Packer imaging. Host routing enables IP forwarding without installing custom firewall allow rules.
- Builds trigger on relevant changes to `main`, with YAML variables replacing runtime inputs and gallery versions generated as `0.1.$(Build.BuildId)`.
- Added `EVE_PIPELINE_ENABLED` to skip build work when disabled.
- Shell provisioning stops on command and shell-pipeline failures.

### Fixed

- Disabled the optional `command-not-found` APT configuration before package updates to avoid build failures from missing CNF metadata. Its configuration is preserved at `/etc/apt/50command-not-found.disabled`.

### Deployment notes

- Build and publish a new image, then select its exact version in `eve_dev.yml`. Changing the source image normally replaces the VM; back up labs, router configurations, and DHCP leases before applying.
- Connect router management interfaces to Cloud1 / `pnet1`. DHCP supplies the gateway; static addresses should be outside the dynamic pool. Use unique addresses across concurrently running labs.
- Include `172.16.1.0/24` in WireGuard client routes, or configure the equivalent Azure VPN client and gateway routes. Router management routing tables must return traffic to VPN clients through `172.16.1.1`.
- Infinite leases survive ordinary reboots through the persistent lease file. Retaining assignments across VM replacement requires restoring that file and preserving client MAC addresses/client IDs. Retired clients' leases may require cleanup.
- Existing host firewall policies must permit forwarding and DHCP. Management routing does not provide Internet NAT for router-originated traffic.

## iPerf — Unreleased

### Changed

- Builds trigger on relevant changes to `main`, with YAML variables replacing runtime inputs and gallery versions generated as `0.1.$(Build.BuildId)`.
- Added `IPERF_PIPELINE_ENABLED` to skip build work when disabled.
- Shell provisioning stops on command and shell-pipeline failures.

### Deployment notes

- Select the published gallery version using `iperfImageVersion` in `iperf_dev.yml`. Review the replacement plan and preserve any VM-local data before applying a new source image.
