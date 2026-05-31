resource "azurerm_storage_account" "azstacc" {
  name                     = var.storageaccountname
  resource_group_name      = var.rsgrp
  location                 = var.region
  account_kind             = var.accountkind 
  account_tier             = ( var.accountkind == "StorageV2" || var.accountkind == "BlobStorage" ) ? "Standard" : "Premium"
  account_replication_type = var.replication_type
  access_tier              = var.accesstier
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = var.storageversioning
    container_delete_retention_policy {
      days = var.containerdataretention
    }
    delete_retention_policy {
      days = var.blobdataretention
    }
    dynamic "cors_rule" {
      for_each = var.corsrules
      content {
        allowed_headers    = cors_rule.value.allowed_headers
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_origins    = cors_rule.value.allowed_origins
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }
  }
}

resource "azurerm_storage_account_static_website" "azstaticweb" {
  storage_account_id = azurerm_storage_account.azstacc.id
  error_404_document = var.html_error_page
  index_document     = var.index_document
}