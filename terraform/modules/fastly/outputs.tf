output "fastly_service_id" {
  description = "The ID of the Fastly VCL service"
  value       = fastly_service_vcl.cdn.id
}

output "fastly_service_version" {
  description = "The active version number of the Fastly service"
  value       = fastly_service_vcl.cdn.active_version
}

output "fastly_domain" {
  description = "The Fastly CDN domain serving the static website"
  value       = var.fastly_domain
}
