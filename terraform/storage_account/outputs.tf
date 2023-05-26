output "account_name" {
  value = azurerm_storage_account.main.name
}
output "account_access_key" {
  value = azurerm_storage_account.main.primary_access_key
}