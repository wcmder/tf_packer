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
└── modules/               # Legacy local modules; no longer referenced
```

The EVE-NG and iPerf environment roots contain only backend, provider, credential-variable, and stack-call configuration. Resource composition is shared in `main/stacks/eve` and `main/stacks/iperf`. The images root owns the dedicated `dev-use-images-rg`, Azure Compute Gallery, and stable `eve-ng` and `iperf` image definitions; Packer owns the immutable versions beneath those definitions. Reusable Azure resource modules are pinned to `v0.1.1` of the private `TF/azure-terraform-modules` Azure Repos repository.

The environment roots use separate remote-state keys and are intended for clean deployments without legacy state migration.

## Prerequisites

- Terraform 1.14.6 or later
- Azure credentials for the development subscription
- Access to the remote-state storage account
- Read access to `TF/azure-terraform-modules`

The Terraform and Packer pipelines authenticate to Azure with the `sp-test` service principal. The Azure DevOps variable group `dostest01kv01` must expose the `sp-test` client ID and secret through `dostest-spn-id` and `dostest-spn-secret`, the tenant ID through `dostest-tenant-id`, the backend credentials, and `repo-access`, a read-only Azure Repos PAT. The pipeline passes that PAT to Git only during `terraform init`.

`sp-test` requires the Contributor role on the development subscription `a4b57fa5-2f2c-4732-b452-32be7d1724b1`. This allows Terraform to create resource groups and infrastructure and allows Packer to create temporary build resources and publish Azure Compute Gallery versions. It does not grant permission to create Azure role assignments.

The EVE and iPerf Packer pipelines accept an exact Ubuntu version and a new application image version as non-secret runtime parameters. Their deployment pipelines accept the corresponding existing gallery version to deploy. Resolve and review the exact Ubuntu version with `az vm image list --location eastus --publisher Canonical --offer 0001-com-ubuntu-server-jammy --sku 22_04-lts-gen2 --all`; do not build with the `SET_EXACT_VERSION` placeholder.

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

Copy one complete version into `ubuntuImageVersion`. Do not enter `latest` or leave the `SET_EXACT_VERSION` placeholder. To verify a selected version before building:

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

## Updating Git modules

Module source addresses are static and version-pinned. To upgrade, replace every `?ref=v0.1.1` under `main/stacks/eve` and `main/stacks/iperf` with a newly published immutable tag, run `terraform init -upgrade`, and review the full plans before applying.
