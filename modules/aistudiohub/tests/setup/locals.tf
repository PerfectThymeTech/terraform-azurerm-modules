locals {
  prefix                        = "${lower(var.prefix)}-${var.environment}"
  connectivity_delay_in_seconds = 0
}
