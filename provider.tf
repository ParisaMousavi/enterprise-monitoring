terraform {
  # required_providers {
  #   azurerm = {
  #     source  = "hashicorp/azurerm"
  #     version = "3.22.0"
  #   }
  # }

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "parisatfstateaziac2"
    container_name       = "enterprise-monitoring"
    key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
  // Azure Active Directory permissions for service principal
  // https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration#azure-active-directory-permissions
  # client_id       = "6ac8e28a-ae99-4af8-8079-c79debae15c3"
  # client_secret   = var.client_secret
  # tenant_id       = "0f912e8a-5f68-43ec-9075-1533aaa80442"
  # subscription_id = "5e3b4723-73f3-44e1-b1ce-2af3b11369c3"
}