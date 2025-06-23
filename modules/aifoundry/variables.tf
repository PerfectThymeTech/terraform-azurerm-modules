# General variables
variable "location" {
  description = "Specifies the location of all resources."
  type        = string
  sensitive   = false
}

variable "location_private_endpoint" {
  description = "Specifies the location of the private endpoint. Use this variables only if the private endpoint(s) should reside in a different location than the service itself."
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
}

variable "resource_group_name" {
  description = "Specifies the resource group name in which all resources will get deployed."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.resource_group_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "tags" {
  description = "Specifies a key value map of tags to set on every taggable resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

# Service variables
variable "ai_services_name" {
  description = "Specifies the name of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.ai_services_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "ai_services_sku" {
  description = "Specifies the sku of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.ai_services_sku) >= 1
    error_message = "Please specify a valid sku name."
  }
}

variable "ai_services_firewall_bypass_azure_services" {
  description = "Specifies whether Azure Services should be allowed to bypass the firewall of the cognitive service. This is required for some common integration sceanrios but not supported by all ai services."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "ai_services_outbound_network_access_restricted" {
  description = "Specifies the outbound network restrictions of the cognitive service."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = true
}

variable "ai_services_outbound_network_access_allowed_fqdns" {
  description = "Specifies the outbound network allowed fqdns of the cognitive service."
  type        = list(string)
  sensitive   = false
  nullable    = false
  default     = []
  validation {
    condition = alltrue([
      length([for allowed_fqdn in toset(var.ai_services_outbound_network_access_allowed_fqdns) : true if startswith(allowed_fqdn, "http")]) <= 0,
      length([for allowed_fqdn in toset(var.ai_services_outbound_network_access_allowed_fqdns) : true if strcontains(allowed_fqdn, "/")]) <= 0,
    ])
    error_message = "Please specify valid domain names without https or paths. For example, provide \"microsoft.com\" instead of \"https://microsoft.com/mysubpage\"."
  }
}

variable "ai_services_local_auth_enabled" {
  description = "Specifies whether key-based acces should be enabled for the cognitive service."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "ai_services_projects" {
  description = "Specifies the projects that should be deployed within your ai service."
  type = map(object({
    description  = optional(string, "")
    display_name = optional(string, "")
  }))
  sensitive = false
  default   = {}
}

variable "ai_services_cosmosdb_accounts" {
  description = "Specifies the cosmos db account that should be used for your ai service (agent service)."
  type = map(object({
    target      = string
    resource_id = string
    location    = string
  }))
  sensitive = false
  default   = {}
  validation {
    condition     = length([for target in values(var.ai_services_cosmosdb_accounts)[*].target : true if !(startswith(target, "https://") && endswith(target, ".documents.azure.com:443/"))]) <= 0
    error_message = "Please specify a valid target for the storage account connection."
  }
  validation {
    condition     = length([for resource_id in values(var.ai_services_cosmosdb_accounts)[*].resource_id : true if !(length(split("/", resource_id)) == 9)]) <= 0
    error_message = "Please specify a valid resource id for the storage account connection."
  }
}

variable "ai_services_storage_accounts" {
  description = "Specifies the storage account that should be used for your ai service (agent service)."
  type = map(object({
    target      = string
    resource_id = string
    location    = string
  }))
  sensitive = false
  default   = {}
  validation {
    condition     = length([for target in values(var.ai_services_storage_accounts)[*].target : true if !(startswith(target, "https://") && endswith(target, ".blob.core.windows.net/"))]) <= 0
    error_message = "Please specify a valid target for the storage account connection."
  }
  validation {
    condition     = length([for resource_id in values(var.ai_services_storage_accounts)[*].resource_id : true if !(length(split("/", resource_id)) == 9)]) <= 0
    error_message = "Please specify a valid resource id for the storage account connection."
  }
}

variable "ai_services_aisearch_accounts" {
  description = "Specifies the ai search account that should be used for your ai service (agent service)."
  type = map(object({
    target      = string
    resource_id = string
    location    = string
  }))
  sensitive = false
  default   = {}
  validation {
    condition     = length([for target in values(var.ai_services_aisearch_accounts)[*].target : true if !(startswith(target, "https://") && endswith(target, ".search.windows.net"))]) <= 0
    error_message = "Please specify a valid target for the ai search connection."
  }
  validation {
    condition     = length([for resource_id in values(var.ai_services_aisearch_accounts)[*].resource_id : true if !(length(split("/", resource_id)) == 9)]) <= 0
    error_message = "Please specify a valid resource id for the ai search connection."
  }
}

variable "ai_services_connections_account" {
  description = "Specifies the connections that should be created within your ai service account."
  type = map(object({
    auth_type = optional(string, "AAD")
    credentials = optional(object({
      access_key_id     = optional(string, "")
      secret_access_key = optional(string, "")
      key               = optional(string, "")
      client_id         = optional(string, "")
      resource_id       = optional(string, "")
      client_secret     = optional(string, "")
      tenant_id         = optional(string, "")
      pat               = optional(string, "")
      sas               = optional(string, "")
    }), {})
    category                       = string
    target                         = string
    metadata                       = map(string)
    private_endpoint_requirement   = optional(string, "Required")
    use_workspace_managed_identity = optional(bool, true)
  }))
  sensitive = false
  default   = {}
  validation {
    condition = alltrue([
      length([for auth_type in values(var.ai_services_connections_account)[*].auth_type : true if !contains(["AAD", "AccessKey", "AccountKey", "ApiKey", "ManagedIdentity", "PAT", "SAS", "ServicePrincipal", "None"], auth_type)]) <= 0,
    ])
    error_message = "Please specify a valid ai service connection private endpoint configuration requirement."
  }
  validation {
    condition = alltrue([
      length([for category in values(var.ai_services_connections_account)[*].category : true if !contains(["AIServices", "AppInsights", "AmazonMws", "AmazonRdsForOracle", "AmazonRdsForSqlServer", "AmazonRedshift", "AmazonS3Compatible", "ApiKey", "AzureBlob", "AzureDatabricksDeltaLake", "AzureDataExplorer", "AzureMariaDb", "AzureMySqlDb", "AzureOneLake", "AzureOpenAI", "AzurePostgresDb", "AzureStorageAccount", "AzureSqlDb", "AzureSqlMi", "AzureSynapseAnalytics", "AzureTableStorage", "BingLLMSearch", "Cassandra", "CognitiveSearch", "CognitiveService", "Concur", "ContainerRegistry", "CosmosDb", "CosmosDbMongoDbApi", "Couchbase", "CustomKeys", "Db2", "Drill", "Dynamics", "DynamicsAx", "DynamicsCrm", "Elasticsearch", "Eloqua", "FileServer", "FtpServer", "GenericContainerRegistry", "GenericHttp", "GenericRest", "Git", "GoogleAdWords", "GoogleBigQuery", "GoogleCloudStorage", "Greenplum", "Hbase", "Hdfs", "Hive", "Hubspot", "Impala", "Informix", "Jira", "Magento", "ManagedOnlineEndpoint", "MariaDb", "Marketo", "MicrosoftAccess", "MongoDbAtlas", "MongoDbV2", "MySql", "Netezza", "ODataRest", "Odbc", "Office365", "OpenAI", "Oracle", "OracleCloudStorage", "OracleServiceCloud", "PayPal", "Phoenix", "Pinecone", "PostgreSql", "Presto", "PythonFeed", "QuickBooks", "Redis", "Responsys", "S3", "Salesforce", "SalesforceMarketingCloud", "SalesforceServiceCloud", "SapBw", "SapCloudForCustomer", "SapEcc", "SapHana", "SapOpenHub", "SapTable", "Serp", "Serverless", "ServiceNow", "Sftp", "SharePointOnlineList", "Shopify", "Snowflake", "Spark", "SqlServer", "Square", "Sybase", "Teradata", "Vertica", "WebTable", "Xero", "Zoho"], category)]) <= 0,
    ])
    error_message = "Please specify a valid ai service connection category."
  }
  validation {
    condition = alltrue([
      length([for private_endpoint_requirement in values(var.ai_services_connections_account)[*].private_endpoint_requirement : true if !contains(["NotApplicable", "NotRequired", "Required"], private_endpoint_requirement)]) <= 0,
    ])
    error_message = "Please specify a valid ai service connection private endpoint configuration requirement."
  }
}

variable "ai_services_deployments" {
  description = "Specifies the models that should be deployed within your ai service. Only applicable to ai services of kind openai."
  type = map(object({
    model_name        = string
    model_version     = string
    model_api_version = optional(string, "2024-02-15-preview")
    sku_name          = optional(string, "Standard")
    sku_tier          = optional(string, "Standard")
    sku_size          = optional(string, null)
    sku_family        = optional(string, null)
    sku_capacity      = optional(number, 1)
  }))
  sensitive = false
  default   = {}
  # validation {
  #   condition = alltrue([
  #     length([for model_name in values(var.ai_services_deployments)[*].model_name : model_name if !contains(["value1", "value2"], model_name)]) <= 0
  #   ])
  #   error_message = "Please specify a valid model configuration."
  # }
}

# Monitoring variables
variable "diagnostics_configurations" {
  description = "Specifies the diagnostic configuration for the service."
  type = list(object({
    log_analytics_workspace_id = optional(string, ""),
    storage_account_id         = optional(string, "")
  }))
  sensitive = false
  default   = []
  validation {
    condition = alltrue([
      length([for diagnostics_configuration in toset(var.diagnostics_configurations) : diagnostics_configuration if diagnostics_configuration.log_analytics_workspace_id == "" && diagnostics_configuration.storage_account_id == ""]) <= 0
    ])
    error_message = "Please specify a valid resource ID."
  }
}

# Network variables
variable "subnet_id" {
  description = "Specifies the resource id of a subnet in which the private endpoints get created."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_id)) == 11
    error_message = "Please specify a valid subnet id."
  }
}

variable "subnet_id_capability_hosts" {
  description = "Specifies the resource id of a subnet in which the capability hosts get created."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_id_capability_hosts)) == 11
    error_message = "Please specify a valid subnet id."
  }
}

variable "connectivity_delay_in_seconds" {
  description = "Specifies the delay in seconds after the private endpoint deployment (required for the DNS automation via Policies)."
  type        = number
  sensitive   = false
  nullable    = false
  default     = 120
  validation {
    condition     = var.connectivity_delay_in_seconds >= 0
    error_message = "Please specify a valid non-negative number."
  }
}

variable "private_dns_zone_id_ai_services" {
  description = "Specifies the resource ID of the private DNS zone for Azure Foundry (AI Services). Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_ai_services == "" || (length(split("/", var.private_dns_zone_id_ai_services)) == 9 && endswith(var.private_dns_zone_id_ai_services, "privatelink.services.ai.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_cognitive_account" {
  description = "Specifies the resource ID of the private DNS zone for Azure Cognitive Services. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_cognitive_account == "" || (length(split("/", var.private_dns_zone_id_cognitive_account)) == 9 && endswith(var.private_dns_zone_id_cognitive_account, "privatelink.cognitiveservices.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_open_ai" {
  description = "Specifies the resource ID of the private DNS zone for Azure Open AI. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_open_ai == "" || (length(split("/", var.private_dns_zone_id_open_ai)) == 9 && endswith(var.private_dns_zone_id_open_ai, "privatelink.openai.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

# Customer-managed key variables
variable "customer_managed_key" {
  description = "Specifies the customer managed key configurations."
  type = object({
    key_vault_id                     = string,
    key_vault_key_id                 = string,
    key_vault_key_versionless_id     = string,
    user_assigned_identity_id        = string,
    user_assigned_identity_client_id = string,
  })
  sensitive = false
  nullable  = true
  default   = null
  validation {
    condition = alltrue([
      var.customer_managed_key == null || length(split("/", try(var.customer_managed_key.key_vault_id, ""))) == 9,
      var.customer_managed_key == null || startswith(try(var.customer_managed_key.key_vault_key_id, ""), "https://"),
      var.customer_managed_key == null || startswith(try(var.customer_managed_key.key_vault_key_versionless_id, ""), "https://"),
      var.customer_managed_key == null || length(split("/", try(var.customer_managed_key.user_assigned_identity_id, ""))) == 9,
      var.customer_managed_key == null || length(try(var.customer_managed_key.user_assigned_identity_client_id, "")) >= 2,
    ])
    error_message = "Please specify a valid resource ID."
  }
}
