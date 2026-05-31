output "storage_account_id" {
  value = azurerm_storage_account.azstacc.id
}

output "primarywebendpoint" {
  value = trimsuffix(replace(azurerm_storage_account.azstacc.primary_web_endpoint, "https://", ""), "/")
}

output "primarystaticwebsitehostname" {
  value = azurerm_storage_account.azstacc.primary_web_host
}