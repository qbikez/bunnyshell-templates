resource "azurerm_servicebus_namespace" "main" {
  name                = "bns${var.instance_suffix}sb"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_servicebus_namespace_authorization_rule" "listen_and_send" {
  name         = "listen_and_send"
  namespace_id = azurerm_servicebus_namespace.main.id

  listen = true
  send   = true
  manage = false
}

resource "azurerm_servicebus_topic" "payments" {
  name         = "payments"
  namespace_id = azurerm_servicebus_namespace.main.id

  enable_partitioning = true
}

resource "azurerm_servicebus_subscription" "payment-processing" {
  name               = "payment-processing"
  topic_id           = azurerm_servicebus_topic.payments.id
  max_delivery_count = 1
  default_message_ttl = "PT1M" 
}

resource "azurerm_servicebus_subscription" "payment-completed" {
  name               = "orders"
  topic_id           = azurerm_servicebus_topic.payments.id
  max_delivery_count = 1
  default_message_ttl = "PT1M" 
}