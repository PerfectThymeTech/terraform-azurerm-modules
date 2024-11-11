locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  # Resource id's
  virtual_network = {
    name                = reverse(split("/", var.virtual_network_id))[0]
    resource_group_name = split("/", var.virtual_network_id)[4]
  }
}
