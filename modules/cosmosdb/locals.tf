locals {
  private_dns_zones_map = {
    Sql         = var.private_dns_zone_id_cosmos_sql
    MongoDB     = var.private_dns_zone_id_cosmos_mongodb
    Cassandra   = var.private_dns_zone_id_cosmos_cassandra
    Gremlin     = var.private_dns_zone_id_cosmos_gremlin
    Table       = var.private_dns_zone_id_cosmos_table
    Analytical  = var.private_dns_zone_id_cosmos_analytical
    coordinator = var.private_dns_zone_id_cosmos_coordinator
  }
}
