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

1. Apply the images root to create the stable `eve-ng` and `iperf` definitions.
2. Run the applicable Packer pipeline with an exact Ubuntu version and a new application version; Packer publishes that gallery version directly.
3. Run the matching deployment pipeline with the same application version; Terraform deploys the VM from that exact gallery version.

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
