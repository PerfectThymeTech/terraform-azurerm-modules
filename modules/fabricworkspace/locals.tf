locals {
  fabric_capity_ids = [
    for value in data.fabric_capacities.capacities.values :
    id if value.display_name == one(data.azapi_resource.fabric_capacity[*].name) && value.region == one(data.azapi_resource.fabric_capacity[*].location) && value.sku == one(data.azapi_resource.fabric_capacity[*].sku)
  ]
  fabric_capity_id = length(local.fabric_capity_ids) > 0 ? local.fabric_capity_ids[0] : null
}
