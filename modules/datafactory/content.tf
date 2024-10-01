resource "azurerm_resource_group_template_deployment" "data_factory_content_deployment" {
  count = var.data_factory_published_content.parameters_file != "" && var.data_factory_published_content.template_file != "" ? 1 : 0

  name                = "dataFactoryContentDeployment-${timestamp()}"
  resource_group_name = azurerm_data_factory.data_factory.resource_group_name
  tags                = var.tags

  debug_level        = "none"
  deployment_mode    = "Incremental"
  parameters_content = jsonencode(jsondecode(templatefile(var.data_factory_published_content.parameters_file, var.data_factory_published_content_template_variables)).parameters)
  template_content   = file(var.data_factory_published_content.template_file)
}

resource "null_resource" "data_factory_triggers_start" {
  for_each = var.data_factory_published_content.parameters_file != "" && var.data_factory_published_content.template_file != "" ? toset(var.data_factory_triggers_start) : toset([])

  provisioner "local-exec" {
    command = "az datafactory trigger start --resource-group ${azurerm_data_factory.data_factory.resource_group_name} --factory-name ${azurerm_data_factory.data_factory.name} --name ${each.value} --subscription ${data.azurerm_subscription.current.subscription_id}"
  }

  depends_on = [
    azurerm_resource_group_template_deployment.data_factory_content_deployment
  ]
}

resource "null_resource" "data_factory_pipelines_run" {
  for_each = var.data_factory_published_content.parameters_file != "" && var.data_factory_published_content.template_file != "" ? toset(var.data_factory_pipelines_run) : toset([])

  provisioner "local-exec" {
    command = "az datafactory pipeline create-run --resource-group ${azurerm_data_factory.data_factory.resource_group_name} --factory-name ${azurerm_data_factory.data_factory.name} --name ${each.value} --subscription ${data.azurerm_subscription.current.subscription_id}"
  }

  depends_on = [
    azurerm_resource_group_template_deployment.data_factory_content_deployment,
  ]
}
