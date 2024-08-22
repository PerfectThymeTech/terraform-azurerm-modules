locals {
  application_insights = {
    name                = split(var.bot_service_application_insights_id, "/")[8]
    resource_group_name = split(var.bot_service_application_insights_id, "/")[4]
  }
}
