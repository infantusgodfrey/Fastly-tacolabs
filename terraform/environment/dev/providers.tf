terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.73.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.9.0"
    }
    fastly = {
      source  = "fastly/fastly"
      version = "= 9.1.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "fastly" {
  api_key = var.fastly_api_key
}
