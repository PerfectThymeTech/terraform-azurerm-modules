run "create_fabric_capacity" {
  command = apply

  variables {
    location            = "germanywestcentral"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "data-factory"
    }
    data_factory_name              = "tftst-adf001"
    data_factory_purview_id        = null
    data_factory_azure_devops_repo = {}
    data_factory_github_repo       = {}
    data_factory_global_parameters = {}
    data_factory_published_content = {
      parameters_file = "./tests/adf/ARMTemplateParametersForFactory.json"
      template_file   = "./tests/adf/ARMTemplateForFactory.json"
    }
    data_factory_published_content_template_variables = {
      data_factory_name = "tftst-adf001"
    }
    data_factory_triggers_start            = []
    data_factory_pipelines_run             = []
    data_factory_managed_private_endpoints = {}
    diagnostics_configurations             = []
    subnet_id                              = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds          = 0
    private_dns_zone_id_data_factory       = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.datafactory.azure.net"
    customer_managed_key                   = null
  }

  assert {
    condition     = azurerm_data_factory.data_factory.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
