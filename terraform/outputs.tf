output "account_name" {
  value = azurerm_storage_account.main.name
}
output "account_access_key" {
  value = azurerm_storage_account.main.primary_access_key
  sensitive = true
}

output "servicebus_connectionstring" {
  value = azurerm_servicebus_namespace_authorization_rule.listen_and_send.primary_connection_string
  sensitive = true
}