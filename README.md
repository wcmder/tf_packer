# Azure EVE-NG and Packer

This repository builds Azure managed images with Packer and deploys an EVE-NG lab with Terraform.

## Structure

```text
main/
├── env/dev/use/
│   ├── eve/               # Thin EVE-NG Terraform root
│   ├── images/            # Gallery and stable image definitions
│   └── iperf/             # Thin iPerf Terraform root
├── stacks/
│   ├── context/           # Shared naming, tags, region, and CIDRs
│   ├── eve/               # EVE-NG resource composition
│   ├── images/            # Azure Compute Gallery foundation
│   └── iperf/             # iPerf resource composition
├── packer/                # Environment-independent image templates
│   ├── eve/
│   └── iperf/
├── pipelines/             # Terraform and Packer pipelines
└── modules/               # Legacy local modules; no longer referenced, deleted
```

The EVE-NG and iPerf environment roots contain only backend, provider, credential-variable, and stack-call configuration. Resource composition is shared in `main/stacks/eve` and `main/stacks/iperf`. The images root owns the dedicated `dev-use-images-rg`, Azure Compute Gallery, and stable `eve-ng` and `iperf` image definitions; Packer owns the immutable versions beneath those definitions. Reusable Azure resource modules are pinned to `v0.1.6` of the private `TF/azure-terraform-modules` Azure Repos repository.

The environment roots use separate remote-state keys and are intended for clean deployments without legacy state migration.

## Prerequisites

- Terraform 1.14.6 or later
- Azure credentials for the development subscription
- Access to the remote-state storage account
- Read access to `TF/azure-terraform-modules`

The Terraform and Packer pipelines authenticate to Azure with the `sp-test` service principal. The Azure DevOps variable group `dostest01kv01` must expose the `sp-test` client ID and secret through `dostest-spn-id` and `dostest-spn-secret`, the tenant ID through `dostest-tenant-id`, the backend credentials, and `repo-access`, a read-only Azure Repos PAT. The pipeline passes that PAT to Git only during `terraform init`.

`sp-test` requires the Contributor role on the development subscription `a4b57fa5-2f2c-4732-b452-32be7d1724b1`. This allows Terraform to create resource groups and infrastructure and allows Packer to create temporary build resources and publish Azure Compute Gallery versions. It does not grant permission to create Azure role assignments.

The EVE and iPerf Packer pipelines accept an exact Ubuntu version and a new application image version as non-secret runtime parameters. `ubuntuImageVersion` defaults to the pinned version `22.04.202608060` and can be changed when manually starting either pipeline. Their deployment pipelines accept the corresponding existing gallery version to deploy. Resolve and review alternative Ubuntu versions with `az vm image list --location eastus --publisher Canonical --offer 0001-com-ubuntu-server-jammy --sku 22_04-lts-gen2 --all`.

## Image publication workflow

Use this order:

1. Run `images_dev.yml` to create the `dev-use-images-rg` resource group, `image_gallery` Azure Compute Gallery, and stable `eve-ng` and `iperf` image definitions.
2. Run the applicable Packer pipeline with an exact Ubuntu version and a new application version; Packer publishes that gallery version directly.
3. Run the matching deployment pipeline with the same application version; Terraform deploys the VM from that exact gallery version.

### Select the manual pipeline inputs

First, clear any stale Azure CLI account cache, authenticate against the correct tenant with device-code flow, and select the development subscription. The scope value must be the plain URL shown below, without Markdown link brackets or parentheses:

```bash
az account clear
az login \
  --tenant e997af8c-9bfb-4955-b553-23a019d94051 \
  --use-device-code \
  --scope 'https://management.core.windows.net//.default'

az account set \
  --subscription a4b57fa5-2f2c-4732-b452-32be7d1724b1

az account show \
  --query '{user:user.name, subscription:name, subscriptionId:id, tenantId:tenantId}' \
  --output table
```

When manually running `eve_packer.yml` or `iperf_packer.yml`, select the branch containing the Packer configuration you want to build. Normally this is `main`; select a feature branch only when testing unmerged changes. The pipeline YAML is loaded from the selected branch.

Find recent exact Ubuntu Marketplace versions matching the Packer source image:

```bash
az vm image list \
  --location eastus \
  --publisher Canonical \
  --offer 0001-com-ubuntu-server-jammy \
  --sku 22_04-lts-gen2 \
  --all \
  --query "reverse(sort_by([], &version))[:10].version" \
  --output table
```

Use the default pinned version or copy another complete version into `ubuntuImageVersion` when starting the pipeline. Do not enter `latest`. To verify a selected version before building:

```bash
az vm image show \
  --location eastus \
  --publisher Canonical \
  --offer 0001-com-ubuntu-server-jammy \
  --sku 22_04-lts-gen2 \
  --version <exact-ubuntu-version> \
  --output table
```

The EVE or iPerf gallery version is assigned by this project and must have a numeric `major.minor.patch` format, such as `0.1.0` or `0.1.1`. Check which versions already exist before selecting a new one:

```bash
# EVE-NG versions
az sig image-version list \
  --resource-group dev-use-images-rg \
  --gallery-name image_gallery \
  --gallery-image-definition eve-ng \
  --query "[].name" \
  --output table

# iPerf versions
az sig image-version list \
  --resource-group dev-use-images-rg \
  --gallery-name image_gallery \
  --gallery-image-definition iperf \
  --query "[].name" \
  --output table
```

Use a version that does not already exist. The pipelines deliberately do not replace existing gallery versions. For example, an EVE build could use:

```text
Branch:              main
ubuntuImageVersion:  <exact-version-returned-by-az-cli>
eveImageVersion:     0.1.0
```

After the Packer pipeline succeeds, run `eve_dev.yml` with the same `eveImageVersion`, or `iperf_dev.yml` with the same `iperfImageVersion`, to deploy a VM from that exact gallery version.

### Check the EVE installer SHA-256 manually

The EVE pipeline checks the upstream installer against `eve_installer_sha256` in [main/packer/eve/build.pkr.hcl](main/packer/eve/build.pkr.hcl) before creating the build VM or downloading appliance images. A download failure or checksum mismatch stops the build. Packer also verifies the checksum inside the VM before executing the installer.

From the repository root, download the installer without executing it and calculate its SHA-256 on macOS or Linux:

```bash
(
  set -euo pipefail
  eve_installer_dir=$(mktemp -d)
  curl --fail --show-error --location \
    --connect-timeout 15 --max-time 60 \
    --output "$eve_installer_dir/install-eve.sh" \
    https://www.eve-ng.net/jammy/install-eve.sh

  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$eve_installer_dir/install-eve.sh"
  else
    shasum -a 256 "$eve_installer_dir/install-eve.sh"
  fi

  # Display the expected hash stored in the Packer configuration.
  rg '^  eve_installer_sha256 =' main/packer/eve/build.pkr.hcl
  echo "Downloaded installer retained for review: $eve_installer_dir/install-eve.sh"
)
```

Compare the calculated 64-character hash with the pinned value. If they differ, review the downloaded script and the upstream changes before replacing `eve_installer_sha256` in `build.pkr.hcl` with the new hash. Do not update the pin solely to bypass a failed check. If `eve_installer_url` changes, use that URL in the command above as well.

Commit and push the reviewed checksum change to `main` to trigger a new EVE build. The preflight check will use the updated value automatically.

## Run locally

Authenticate to the private module repository with Git Credential Manager, then run:

```bash
cd main/env/dev/use/eve
terraform init -upgrade -reconfigure \
  -backend-config="access_key=<backend-access-key>"
terraform fmt -check
terraform validate
terraform plan \
  -var="spn-client-id=<client-id>" \
  -var="spn-client-secret=<client-secret>" \
  -var="spn-tenant-id=<tenant-id>"
```

Review every plan carefully before applying it.

## Stop and start the EVE-NG lab VM

Deallocate the EVE-NG VM when the lab is idle to stop its compute charges:

```bash
az vm deallocate \
  --resource-group dev-use-lab-rg \
  --name dev-use-lab-eveng1-vm
```

Start the VM again before using the lab:

```bash
az vm start \
  --resource-group dev-use-lab-rg \
  --name dev-use-lab-eveng1-vm
```

Check its current power state:

```bash
az vm get-instance-view \
  --resource-group dev-use-lab-rg \
  --name dev-use-lab-eveng1-vm \
  --query "instanceView.statuses[?starts_with(code, 'PowerState/')].displayStatus | [0]" \
  --output tsv
```

Shutting down EVE-NG from inside the guest operating system might leave the Azure VM allocated. Use `az vm deallocate` and confirm the state is `VM deallocated` to stop compute billing. Managed disks, public IP addresses, and the VPN gateway continue to incur charges while the VM is deallocated.

## WireGuard remote access stack

`main/stacks/eve_wg` is the lower-cost alternative to the Azure VPN Gateway EVE stack. WireGuard runs directly on the EVE-NG VM. The stack creates one Standard public IP, permits only UDP port `51820` from the Internet, installs WireGuard with an Azure VM extension, enables IPv4 forwarding and NAT, and does not create a VPN gateway or `GatewaySubnet`.

The `main/env/dev/use/eve` root uses `main/stacks/eve_wg` to replace the Azure VPN Gateway implementation.

Install the WireGuard command-line tools on the Mac, then generate a client key pair. Keep the private key only on the Mac:

```bash
brew install wireguard-tools
mkdir -p ~/.config/wireguard
chmod 700 ~/.config/wireguard
cd ~/.config/wireguard
umask 077
wg genkey | tee macbook-private.key | wg pubkey > macbook-public.key
cat macbook-public.key
```

Add only the client public key and a unique address to the stack call:

```hcl
wireguard_peers = {
  macbook = {
    public_key = "<contents-of-macbook-public.key>"
    address    = "172.16.0.2/32"
  }
}
```

Run Terraform plan and apply after adding the peer. Use a different key and client address, such as `172.16.0.3/32`, for every additional device.

After applying Terraform, retrieve the generated server public key through the Azure control plane:

```bash
az vm run-command invoke \
  --resource-group dev-use-lab-rg \
  --name dev-use-lab-eveng1-vm \
  --command-id RunShellScript \
  --scripts "cat /etc/wireguard/server.pub" \
  --query "value[0].message" \
  --output tsv
```

Get the public WireGuard endpoint and the private EVE address:

```bash
az network public-ip show \
  --resource-group dev-use-lab-rg \
  --name dev-use-lab-eve-wg-pip \
  --query ipAddress \
  --output tsv

az vm list-ip-addresses \
  --resource-group dev-use-lab-rg \
  --name dev-use-lab-eveng1-vm \
  --query "[0].virtualMachine.network.privateIpAddresses[0]" \
  --output tsv
```

Create `~/.config/wireguard/eve-wg.conf` using the locally generated private key:

```ini
[Interface]
PrivateKey = <contents-of-macbook-private.key>
Address = 172.16.0.2/32

[Peer]
PublicKey = <server-public-key>
Endpoint = <wireguard-public-ip>:51820
AllowedIPs = 172.16.0.0/24, 10.0.4.0/25
PersistentKeepalive = 25
```

Start the tunnel and verify that a recent handshake appears:

```bash
sudo wg-quick up ~/.config/wireguard/eve-wg.conf
sudo wg show
```

Access EVE-NG at `https://<eve-private-ip>`. Stop the tunnel with:

```bash
sudo wg-quick down ~/.config/wireguard/eve-wg.conf
```

Alternatively, install the WireGuard app from the macOS App Store, import `eve-wg.conf`, and activate the tunnel in the app. Deallocating the EVE VM also stops the WireGuard endpoint; start the VM before connecting.

## Updating Git modules

Module source addresses are static and version-pinned. To upgrade a module, replace its existing `?ref=<tag>` with a newly published immutable tag, run `terraform init -upgrade`, and review the full plans before applying.
