terraform {
  required_version = ">=0.13"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.14.0"
    }
  }
}
