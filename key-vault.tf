resource "azurerm_resource_group" "keyvault" {
  name     = "${var.friendly_prefix}-key-vault-rg"
  location = var.location
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "${var.friendly_prefix}-kv"
  location                    = azurerm_resource_group.keyvault.location
  resource_group_name         = azurerm_resource_group.keyvault.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  dynamic "access_policy" {
    for_each = var.read_permitted_object_ids
    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value

      key_permissions = [
        "Get",
        "List",
        "Verify"
      ]

      certificate_permissions = [
        "Get",
        "GetIssuers",
        "List",
        "ListIssuers"
      ]

      secret_permissions = [
        "Get",
        "List"
      ]
    }
  }


  dynamic "access_policy" {

    for_each = concat([data.azurerm_client_config.current.object_id], var.admin_permitted_object_ids)
    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value

      key_permissions = [
        "Backup",
        "Create",
        "Decrypt",
        "Delete",
        "Encrypt",
        "Get",
        "Import",
        "List",
        "Purge",
        "Recover",
        "Restore",
        "Sign",
        "UnwrapKey",
        "Update",
        "Verify",
        "WrapKey"
      ]

      certificate_permissions = [
        "Create",
        "Delete",
        "DeleteIssuers",
        "Get",
        "GetIssuers",
        "Import",
        "List",
        "ListIssuers",
        "ManageContacts",
        "ManageIssuers",
        "Purge",
        "Recover",
        "Restore",
        "SetIssuers",
        "Update"
      ]

      secret_permissions = [
        "Backup",
        "Delete",
        "Get",
        "List",
        "Purge",
        "Recover",
        "Restore",
        "Set"
      ]
    }
  }

}

resource "azurerm_log_analytics_workspace" "ds-kv" {
  name                = "${var.friendly_prefix}-wskv"
  location            = azurerm_resource_group.keyvault.location
  resource_group_name = azurerm_resource_group.keyvault.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "ds-kv" {
  name                       = "${var.friendly_prefix}-ds-kv"
  target_resource_id         = azurerm_key_vault.keyvault.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.ds-kv.id

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 7
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 7
    }
  }
}

resource "azurerm_log_analytics_solution" "la-sol-kv" {
  solution_name         = "${var.friendly_prefix}sol"
  location              = azurerm_resource_group.keyvault.location
  resource_group_name   = azurerm_resource_group.keyvault.name
  workspace_resource_id = azurerm_log_analytics_workspace.ds-kv.id
  workspace_name        = azurerm_log_analytics_workspace.ds-kv.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/KeyVaultAnalytics"
  }

  depends_on = [azurerm_monitor_diagnostic_setting.ds-kv]
}