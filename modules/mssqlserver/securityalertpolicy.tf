resource "azurerm_mssql_server_security_alert_policy" "mssql_server_security_alert_policy" {
  server_name         = azurerm_mssql_server.mssql_server.name
  resource_group_name = azurerm_mssql_server.mssql_server.resource_group_name

  disabled_alerts            = var.mssql_server_security_alert_policy.disabled_alerts
  email_account_admins       = var.mssql_server_security_alert_policy.email_account_admins
  email_addresses            = var.mssql_server_security_alert_policy.email_addresses
  retention_days             = var.mssql_server_security_alert_policy.retention_days
  state                      = var.mssql_server_security_alert_policy.enabled ? "Enabled" : "Disabled"
  storage_endpoint           = var.mssql_server_security_alert_policy.storage_endpoint
  storage_account_access_key = var.mssql_server_security_alert_policy.storage_account_access_key
  # disabled_alerts = [
  #   "Access_Anomaly",
  #   "Data_Exfiltration",
  #   "Sql_Injection",
  #   "Sql_Injection_Vulnerability",
  #   "Unsafe_Action",
  # ]
}

resource "azurerm_mssql_server_vulnerability_assessment" "mssql_server_vulnerability_assessment" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.mssql_server_security_alert_policy.id

  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                    = var.mssql_server_security_alert_policy.emails
  }
  storage_container_path     = "${var.mssql_server_security_alert_policy.storage_endpoint}${var.mssql_server_security_alert_policy.storage_container}/"
  storage_account_access_key = var.mssql_server_security_alert_policy.storage_account_access_key
}
