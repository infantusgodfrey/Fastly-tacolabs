# Fastly Static Website Terraform

This repository demonstrates how to deploy a static website to Azure Storage and serve it through Fastly CDN using Terraform.

## Overview

The project provisions:

- An Azure Resource Group
- An Azure Storage Account with static website hosting enabled
- A blob container for the static website content
- A Fastly service configured to use the Azure static website endpoint as its origin

The repository includes a sample static website under `Fastlydemo/`.

## Repository Structure

- `Fastlydemo/` - sample static website files to publish
- `terraform/environment/dev/` - Terraform deployment workspace for the dev environment
- `terraform/modules/storageaccount/` - module to create Azure Storage Account and static website configuration
- `terraform/modules/blob/` - module to upload website files into Azure Storage blobs
- `terraform/modules/fastly/` - module to create the Fastly CDN service and backend configuration

## Prerequisites

- Terraform installed (1.5+ recommended)
- Azure CLI or another Azure authentication method
- Azure subscription with permissions to create storage and resource groups
- Fastly account and API key

## Deployment

1. Open a terminal in `terraform/environment/dev/`

   ```powershell
   cd d:\github\selfstudy\terraform\azure\fastly-staticwebsite-terraform\template\environment\dev
   ```

2. Initialize Terraform:

   ```powershell
   terraform init
   ```

3. Review the plan:

   ```powershell
   terraform plan -var "subscription_id=<AZURE_SUBSCRIPTION_ID>" -var "fastly_api_key=<FASTLY_API_KEY>" -var "fastly_domain=<FASTLY_DOMAIN>"
   ```

4. Apply the configuration:

   ```powershell
   terraform apply -var "subscription_id=<AZURE_SUBSCRIPTION_ID>" -var "fastly_api_key=<FASTLY_API_KEY>" -var "fastly_domain=<FASTLY_DOMAIN>"
   ```

5. After successful apply, Terraform outputs include:

   - `primary_static_website_url` - Azure Storage static website origin URL
   - `fastly_service_id` - Fastly service resource ID
   - `fastly_cdn_domain` - Fastly domain serving the site

## Important Configuration

The Terraform configuration is driven by variables defined in `terraform/environment/dev/variable.tf`.

Key values you may want to configure:

- `subscription_id` - Azure subscription ID
- `rsgrp` - Azure resource group name
- `region` - Azure region
- `storageaccountname` - Storage account name
- `sitefolder` - Local site folder to upload (default: `Fastlydemo`)
- `fastly_api_key` - Fastly API key
- `fastly_domain` - CDN domain configured in Fastly

## Site Content

The demo website content is stored in `Fastlydemo/` and uploaded via the `terraform/modules/blob` module. The deployment uses the `$web` container and Azure Storage static website hosting.

## Security and GitHub Publishing

- Do not commit or publish secrets such as `fastly_api_key` or Azure credentials.
- Treat `*.tfvars` files containing sensitive values as local-only configuration.
- If using a file like `dev.auto.tfvars`, remove or replace secret values before publishing.

## Cleanup

To destroy the resources created by this deployment:

```powershell
cd d:\github\selfstudy\terraform\azure\fastly-staticwebsite-terraform\template\environment\dev
terraform destroy -var "subscription_id=<AZURE_SUBSCRIPTION_ID>" -var "fastly_api_key=<FASTLY_API_KEY>" -var "fastly_domain=<FASTLY_DOMAIN>"
```

## Notes

- The Fastly provider is configured in `terraform/environment/dev/providers.tf`.
- The site upload path is resolved from `terraform/environment/dev/main.tf` using `sitefolder`.
- This repo is intended as a sample deployment pattern for Azure static website hosting combined with Fastly CDN.
