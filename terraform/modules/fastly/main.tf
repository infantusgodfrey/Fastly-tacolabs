terraform {
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = "= 9.1.1"
    }
  }
}

resource "fastly_service_vcl" "cdn" {
  name    = var.fastly_service_name
  comment = "Fastly CDN service for Azure static website"

  domain {
    name    = var.fastly_domain
    comment = "Primary CDN domain"
  }

  backend {
    name              = var.fastly_backend_name
    address           = var.origin_hostname
    port              = 443
    use_ssl           = true
    ssl_cert_hostname = var.origin_hostname
    ssl_sni_hostname  = var.origin_hostname
    override_host     = var.origin_hostname

    connect_timeout       = var.backend_settings.connect_timeout
    first_byte_timeout    = var.backend_settings.first_byte_timeout
    between_bytes_timeout = var.backend_settings.between_bytes_timeout

    healthcheck = var.healthcheck_settings.name
  }

  healthcheck {
    name          = var.healthcheck_settings.name
    host          = var.origin_hostname
    path          = var.healthcheck_settings.path
    method        = var.healthcheck_settings.method
    threshold     = var.healthcheck_settings.threshold
    window        = var.healthcheck_settings.window
    initial       = var.healthcheck_settings.initial
    check_interval = var.healthcheck_settings.check_interval
    timeout       = var.healthcheck_settings.timeout
  }

  request_setting {
    name      = "force-ssl"
    force_ssl = var.force_ssl
  }

  gzip {
    name          = "gzip-common"
    content_types = var.gzip_content_types
    extensions    = var.gzip_extensions
  }

  dynamic "header" {
    for_each = var.response_headers
    content {
      name        = header.value.name
      type        = header.value.type
      action      = header.value.action
      destination = header.value.destination
      source      = header.value.source
    }
  }

  cache_setting {
    name            = "default-cache"
    action          = var.cache_settings.action
    ttl             = var.cache_settings.ttl
    stale_ttl       = var.cache_settings.stale_ttl
    cache_condition = ""
  }

  force_destroy = var.force_destroy
  activate      = var.activate_service
}
