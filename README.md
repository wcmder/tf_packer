# Azure EVE-NG and Packer

This repository builds Azure managed images with Packer and deploys an EVE-NG lab with Terraform.

## Structure

```text
main/
├── env/dev/use/
│   ├── eve/               # Thin EVE-NG Terraform root
│   └── iperf/             # Thin iPerf Terraform root
├── stacks/
│   ├── context/           # Shared naming, tags, region, and CIDRs
│   ├── eve/               # EVE-NG resource composition
│   └── iperf/             # iPerf resource composition
├── packer/                # Environment-independent image templates
│   ├── eve/
│   └── iperf/
├── pipelines/             # Terraform and Packer pipelines
└── modules/               # Legacy local modules; no longer referenced
```

The EVE-NG and iPerf environment roots contain only backend, provider, credential-variable, state-migration, and stack-call configuration. Resource composition is shared in `main/stacks/eve` and `main/stacks/iperf`. Reusable Azure resource modules are pinned to `v0.1.1` of the private `TF/azure-terraform-modules` Azure Repos repository.

The previous `main/dev/use/eve` and `main/dev/use/iperf` roots have been retired. Their existing state keys are reused by the new roots, and each `moved.tf` maps the prior module addresses into its stack.

## Prerequisites

- Terraform 1.14.6 or later
- Azure credentials for the development subscription
- Access to the remote-state storage account
- Read access to `TF/azure-terraform-modules`

The Azure DevOps variable group `dostest01kv01` must expose the existing service-principal and backend secrets plus `repo-access`, a read-only Azure Repos PAT. The pipeline passes that PAT to Git only during `terraform init`.

The EVE image pipeline also requires these pinned-build values in that variable group:

- `ubuntu-image-version`: exact Canonical Ubuntu 22.04 Gen2 Marketplace version

Resolve and review the Ubuntu version with `az vm image list --location eastus --publisher Canonical --offer 0001-com-ubuntu-server-jammy --sku 22_04-lts-gen2 --all`.

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

Review the first plan carefully. The included moved blocks cover module nesting and image modules, but the shared module release also has newer collection-shaped inputs that can change nested resource addresses.

## Updating Git modules

Module source addresses are static and version-pinned. To upgrade, replace every `?ref=v0.1.1` under `main/stacks/eve` and `main/stacks/iperf` with a newly published immutable tag, run `terraform init -upgrade`, and review the full plans before applying.
