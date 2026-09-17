# Image changelog

Changes to the EVE-NG and iPerf Packer images and their build pipelines. The reference below distinguishes image contents from deployment configuration; operational instructions are in [README.md](README.md).

## EVE image versus VM deployment reference

This describes the current repository configuration, not a verified inventory of any running VM. A deployed VM contains the image version selected when it was created.

| Component | Image build — Packer (`eve_packer.yml`) | VM deployment — Terraform (`eve_dev.yml`) |
|---|---|---|
| Operating system and EVE | Updates Ubuntu and installs EVE-NG after verifying the installer checksum | Creates the VM from the selected gallery image version |
| Nested appliance images | Downloads and installs Cisco, Palo Alto firewall, and Panorama QCOW2 files | Uses the appliance files already in the image |
| Router management bridge | Creates persistent Cloud1 / `pnet1` at `172.16.1.1/24`, with no Azure NIC attached | Inherits the bridge from the image |
| Host routing | Enables persistent Linux IPv4 forwarding | Enables forwarding on the Azure NIC; the WireGuard extension also ensures Linux forwarding is enabled |
| DHCP | Installs the `pnet1` DHCP service: `.100–.199`, `/24`, gateway `172.16.1.1`, infinite leases, DNS `8.8.8.8` and `8.8.4.4` | Starts the inherited service at boot; no DHCP provisioning extension |
| WireGuard | Does not bake in WireGuard server keys or peer configuration | The VM extension installs WireGuard, generates server keys if absent, configures peers and NAT, and enables the tunnel service |
| Azure resources | Uses temporary build resources and publishes a gallery image version | Manages the resource group, VNet, subnet, NSG, public IP, NIC, and deployed VM |
| CPU, RAM, and storage | Uses a temporary build VM and a 128 GB image OS disk | Selects the runtime VM size and requests a 512 GB managed OS disk |

The WireGuard NAT rule applies to VPN client traffic from `172.16.0.0/24` except destinations in `172.16.1.0/24`. It does not provide Internet NAT for nested devices. Azure VPN Gateway is an alternative deployment stack: Terraform configures the gateway, advertises the client route, and adds the GatewaySubnet route to the EVE VM.

The gallery foundation is created separately by `images_dev.yml`. Creating EVE labs, connecting nodes to Cloud1, and configuring router APIs happen after VM deployment; the image build only installs the appliance disk files.

### Which changes require an image rebuild?

- **New image:** changes to EVE software, bundled appliances, bridge setup, DHCP options, or the image's host routing script. Build with Packer and select the published version in `eve_dev.yml`; switching source images normally replaces the VM.
- **Terraform deployment only:** changes to runtime VM size, managed OS disk size, Azure networking, WireGuard peers, or the WireGuard script. No image rebuild is needed. Review the plan for restart or replacement effects; the WireGuard script restarts the tunnel when reapplied.
- **Client or lab configuration:** update the Mac's WireGuard routes and each nested device's interfaces, routes, and API settings directly. These are not automatically changed by an image rebuild.

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
- DHCP advertises public DNS servers `8.8.8.8` and `8.8.4.4`; the local dnsmasq DNS service remains disabled. Clients need outbound connectivity and must renew existing leases to obtain the new options.
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
