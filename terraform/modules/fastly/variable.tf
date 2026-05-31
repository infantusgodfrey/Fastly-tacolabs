variable "fastly_service_name" {
  description = "The name of the Fastly VCL service"
  type        = string
}

variable "fastly_domain" {
  description = "The domain name to serve via Fastly CDN (e.g. cdn.example.com or the generated .global.ssl.fastly.net domain)"
  type        = string
}

variable "fastly_backend_name" {
  description = "Logical name for the Fastly backend (origin)"
  type        = string
}

variable "origin_hostname" {
  description = "The Azure static website hostname used as the Fastly origin (without https://)"
  type        = string
}

variable "force_ssl" {
  description = "Force all requests to use HTTPS"
  type        = bool
  default     = true
}

variable "activate_service" {
  description = "Whether to activate the Fastly service version on creation"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow Terraform to destroy the service even if it is active"
  type        = bool
  default     = false
}

variable "backend_settings" {
  description = "Timeout and connection settings for the Fastly backend"
  type = object({
    connect_timeout       = number
    first_byte_timeout    = number
    between_bytes_timeout = number
  })
  default = {
    connect_timeout       = 5000
    first_byte_timeout    = 60000
    between_bytes_timeout = 10000
  }
}

variable "healthcheck_settings" {
  description = "Health check probe settings for the Fastly backend"
  type = object({
    name           = string
    path           = string
    method         = string
    threshold      = number
    window         = number
    initial        = number
    check_interval = number
    timeout        = number
  })
  default = {
    name           = "origin-healthcheck"
    path           = "/"
    method         = "HEAD"
    threshold      = 3
    window         = 5
    initial        = 3
    check_interval = 15000
    timeout        = 5000
  }
}

variable "cache_settings" {
  description = "Default cache behaviour for the Fastly service"
  type = object({
    action    = string
    ttl       = number
    stale_ttl = number
  })
  default = {
    action    = "cache"
    ttl       = 3600
    stale_ttl = 60
  }
  validation {
    condition     = contains(["cache", "pass", "restart"], var.cache_settings.action)
    error_message = "cache_settings.action must be one of: cache, pass, restart."
  }
}

variable "gzip_content_types" {
  description = "MIME types that Fastly should gzip before delivering"
  type        = list(string)
  default = [
    "text/html",
    "text/css",
    "text/javascript",
    "application/javascript",
    "application/json",
    "application/xml",
    "image/svg+xml",
    "text/plain",
    "text/xml"
  ]
}

variable "gzip_extensions" {
  description = "File extensions that Fastly should gzip before delivering"
  type        = list(string)
  default     = ["html", "css", "js", "json", "svg", "xml", "txt"]
}

variable "response_headers" {
  description = "Custom HTTP response headers to set or append at the edge"
  type = list(object({
    name        = string
    type        = string
    action      = string
    destination = string
    source      = string
  }))
  default = [
    {
      name        = "cache-control-header"
      type        = "response"
      action      = "set"
      destination = "http.Cache-Control"
      source      = "\"public, max-age=3600\""
    },
    {
      name        = "x-cdn-header"
      type        = "response"
      action      = "set"
      destination = "http.X-CDN"
      source      = "\"Fastly\""
    }
  ]
}
