# ─────────────────────────────────────────────
# Azure / General
# ─────────────────────────────────────────────

variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
}

variable "rsgrp" {
  description = "The name of the resource group"
  type        = string
  default     = "website-resources"
}

variable "region" {
  description = "Enter the Azure region for the resource group"
  type        = string
  default     = "Central India"
  validation {
    condition     = contains(["West Europe", "East US", "Central US", "North Europe", "West US", "Central India"], var.region)
    error_message = "The region must be one of the specified values."
  }
}

# ─────────────────────────────────────────────
# Storage Account
# ─────────────────────────────────────────────

variable "storageaccountname" {
  description = "The name of the storage account"
  type        = string
  default     = "godyaccount"
  validation {
    condition     = length(var.storageaccountname) >= 5 && length(var.storageaccountname) <= 20
    error_message = "The storage account name must be between 5 and 20 characters long."
  }
}

variable "replication_type" {
  description = "The replication type for the storage account"
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS"], var.replication_type)
    error_message = "The replication type must be one of LRS, GRS, RAGRS, or ZRS."
  }
}

variable "accountkind" {
  description = "Storage account kind"
  type        = string
  default     = "StorageV2"
  validation {
    condition     = contains(["StorageV2", "BlobStorage", "FileStorage"], var.accountkind)
    error_message = "The account kind must be one of StorageV2, BlobStorage, or FileStorage."
  }
}

variable "accesstier" {
  description = "File storage access tier"
  type        = string
  default     = "Hot"
  validation {
    condition     = contains(["Hot", "Cool", "Archive"], var.accesstier)
    error_message = "The access tier must be one of Hot, Cool, or Archive."
  }
}

variable "storageversioning" {
  description = "Enable or disable storage account versioning"
  type        = bool
  default     = true
}

variable "corsrules" {
  description = "CORS rules for the storage account"
  type = list(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = [
    {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD", "POST", "OPTIONS", "MERGE", "PUT"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 200
    }
  ]
}

variable "blobdataretention" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 14
}

variable "containerdataretention" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 14
}

# ─────────────────────────────────────────────
# Blob / Site Upload
# ─────────────────────────────────────────────

variable "containername" {
  description = "Container name for the storage blob"
  type        = string
  default     = "$web"
}

variable "containeraccess" {
  description = "Access level for the storage container"
  type        = string
  default     = "private"
  validation {
    condition     = contains(["private", "blob", "container"], var.containeraccess)
    error_message = "The container access must be one of private, blob, or container."
  }
}

variable "blobtype" {
  description = "The type of the storage blob"
  type        = string
  default     = "Block"
  validation {
    condition     = contains(["Block", "Page", "Append"], var.blobtype)
    error_message = "The blob type must be one of Block, Page, or Append."
  }
}

variable "blobname" {
  description = "The name of the storage blob"
  type        = string
  default     = "godyblobcdn"
}

variable "sitefolder" {
  description = "Static website folder name"
  type        = string
  default     = "Fastlydemo"
}

variable "htmlfile" {
  description = "Configuration for the static website (index and error documents)"
  type = object({
    index_document     = string
    error_404_document = string
  })
  default = {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

# ─────────────────────────────────────────────
# Fastly CDN
# ─────────────────────────────────────────────

variable "fastly_api_key" {
  description = "Fastly API key used to authenticate the Fastly Terraform provider"
  type        = string
  sensitive   = true
}

variable "fastly_service_name" {
  description = "The name of the Fastly VCL service"
  type        = string
  default     = "myFastlyCDNService"
}

variable "fastly_domain" {
  description = "The domain name to serve via Fastly (e.g. cdn.example.com)"
  type        = string
}

variable "fastly_backend_name" {
  description = "Logical name for the Fastly backend (origin)"
  type        = string
  default     = "AzureStaticWebsiteOrigin"
}

variable "fastly_force_ssl" {
  description = "Force all requests to HTTPS at the Fastly edge"
  type        = bool
  default     = true
}

variable "fastly_activate_service" {
  description = "Whether to activate the Fastly service version immediately after creation"
  type        = bool
  default     = true
}

variable "fastly_force_destroy" {
  description = "Allow Terraform destroy to deactivate and delete an active Fastly service"
  type        = bool
  default     = false
}

variable "fastly_backend_settings" {
  description = "Timeout and connection settings for the Fastly backend (all values in milliseconds except max_connections)"
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

variable "fastly_healthcheck_settings" {
  description = "Health probe configuration for the Fastly backend origin"
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

variable "fastly_cache_settings" {
  description = "Default cache behaviour at the Fastly edge"
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
    condition     = contains(["cache", "pass", "restart"], var.fastly_cache_settings.action)
    error_message = "fastly_cache_settings.action must be one of: cache, pass, restart."
  }
}

variable "fastly_gzip_content_types" {
  description = "MIME types that Fastly should gzip at the edge"
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
  validation {
    condition = alltrue([
      for mime in var.fastly_gzip_content_types :
        contains([
          "text/html", "text/css", "text/javascript", "application/javascript",
          "application/json", "application/font", "application/font-sfnt",
          "application/opentype", "application/otf", "application/pkcs7-mime",
          "application/truetype", "application/ttf", "application/vnd.ms-fontobject",
          "application/xhtml+xml", "application/xml", "application/xml+rss",
          "application/x-font-opentype", "application/x-font-truetype",
          "application/x-font-ttf", "application/x-httpd-cgi",
          "application/x-mpegurl", "application/x-opentype", "application/x-otf",
          "application/x-perl", "application/x-ttf", "font/eot", "font/ttf",
          "font/otf", "font/opentype", "image/svg+xml", "text/javascript",
          "text/plain", "text/richtext", "text/tab-separated-values",
          "text/xml", "text/x-script", "text/x-component", "text/x-java-source"
        ], mime)
    ])
    error_message = "All fastly_gzip_content_types values must be from the allowed MIME list."
  }
}

variable "fastly_gzip_extensions" {
  description = "File extensions that Fastly should gzip at the edge"
  type        = list(string)
  default     = ["html", "css", "js", "json", "svg", "xml", "txt"]
}

variable "fastly_response_headers" {
  description = "Custom HTTP response headers injected by Fastly at the edge"
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
