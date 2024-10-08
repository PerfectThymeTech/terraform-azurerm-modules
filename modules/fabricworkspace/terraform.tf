terraform {
  required_version = "~> 1.8"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.14.0"
    }
    fabric = {
      source  = "microsoft/fabric"
      version = "0.1.0-beta.3"
    }
  }
}
