output "storage_account_id" {
  description = "The resource ID of the Azure Storage Account"
  value       = module.storageaccount.storage_account_id
}

output "primary_static_website_url" {
  description = "The primary Azure Static Website endpoint (origin)"
  value       = module.storageaccount.primarywebendpoint
}

output "primary_static_website_hostname" {
  description = "The primary Azure Static Website hostname (used as Fastly origin)"
  value       = module.storageaccount.primarystaticwebsitehostname
}

output "fastly_service_id" {
  description = "The ID of the Fastly VCL service"
  value       = module.fastly.fastly_service_id
}

output "fastly_service_version" {
  description = "The active version number of the Fastly service"
  value       = module.fastly.fastly_service_version
}

output "fastly_cdn_domain" {
  description = "The Fastly CDN domain serving the static website"
  value       = module.fastly.fastly_domain
}
