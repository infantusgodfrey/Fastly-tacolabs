resource "azurerm_storage_blob" "blob" {
  for_each = fileset(var.site_path, "**")

  name                   = each.value
  storage_account_name   = var.storageaccountname
  storage_container_name = var.containername
  type                   = var.blobtype
  source                 = "${var.site_path}/${each.value}"
  content_type           = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
}