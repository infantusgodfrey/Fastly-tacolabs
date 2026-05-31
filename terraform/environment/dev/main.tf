resource "azurerm_resource_group" "resourcegrp" {
  name     = var.rsgrp
  location = var.region
}

module "storageaccount" {
  source                 = "../../modules/storageaccount"
  rsgrp                  = var.rsgrp
  region                 = var.region
  storageaccountname     = var.storageaccountname
  replication_type       = var.replication_type
  accountkind            = var.accountkind
  accesstier             = var.accesstier
  html_error_page        = var.htmlfile.error_404_document
  index_document         = var.htmlfile.index_document
  storageversioning      = var.storageversioning
  corsrules              = var.corsrules
  blobdataretention      = var.blobdataretention
  containerdataretention = var.containerdataretention
  depends_on             = [azurerm_resource_group.resourcegrp]
}

module "blob" {
  source             = "../../modules/blob"
  storage_account_id = module.storageaccount.storage_account_id
  blobname           = var.blobname
  blobtype           = var.blobtype
  site_path          = "${path.root}/../../../${var.sitefolder}"
  storageaccountname = var.storageaccountname
  containeraccess    = var.containeraccess
  containername      = var.containername
  depends_on         = [module.storageaccount]
}

module "fastly" {
  source = "../../modules/fastly"

  providers = {
    fastly = fastly
  }

  fastly_service_name  = var.fastly_service_name
  fastly_domain        = var.fastly_domain
  fastly_backend_name  = var.fastly_backend_name
  origin_hostname      = module.storageaccount.primarywebendpoint
  force_ssl            = var.fastly_force_ssl
  activate_service     = var.fastly_activate_service
  force_destroy        = var.fastly_force_destroy
  backend_settings     = var.fastly_backend_settings
  healthcheck_settings = var.fastly_healthcheck_settings
  cache_settings       = var.fastly_cache_settings
  gzip_content_types   = var.fastly_gzip_content_types
  gzip_extensions      = var.fastly_gzip_extensions
  response_headers     = var.fastly_response_headers

  depends_on = [module.storageaccount]
}
