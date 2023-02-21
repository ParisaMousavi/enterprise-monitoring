
module "rg_name" {
  source             = "github.com/ParisaMousavi/az-naming//rg?ref=2022.10.07"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  assembly           = "monitoring"
  location_shortname = var.location_shortname
}

module "resourcegroup" {
  # https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}
  source   = "github.com/ParisaMousavi/az-resourcegroup?ref=2022.10.07"
  location = var.location
  name     = module.rg_name.result
  tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

#----------------------------------------------------------
# Current Subscription Data Resources
#----------------------------------------------------------

data "azurerm_subscription" "current" {}


module "log_workspace_name" {
  source             = "github.com/ParisaMousavi/az-naming//log-analytics-workspace?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

// 1- create diasetting: https://docs.microsoft.com/en-us/azure/azure-monitor/logs/change-pricing-tier
// 2- Analyze Azure AD activity logs with Azure Monitor logs : https://docs.microsoft.com/en-us/azure/active-directory/reports-monitoring/howto-analyze-activity-logs-log-analytics
// 3- Install and use the log analytics views for Azure Active Directory : https://docs.microsoft.com/en-us/azure/active-directory/reports-monitoring/howto-install-use-log-analytics-views
module "loganalytics" {
  # https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}
  source                          = "github.com/ParisaMousavi/az-log-analytics-workspace?ref=main"
  sku                             = "PerGB2018"
  retention_in_days               = 30
  name                            = module.log_workspace_name.result
  resource_group_name             = module.resourcegroup.name
  location                        = module.resourcegroup.location
  internet_ingestion_enabled      = true
  internet_query_enabled          = true
  cmk_for_query_forced            = false
  local_authentication_disabled   = true
  allow_resource_only_permissions = true
  daily_quota_gb                  = 0.25
  tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}


# resource "azurerm_log_analytics_solution" "this" {
#   solution_name         = "ContainerInsights"
#   location              = var.location
#   resource_group_name   = module.resourcegroup.name
#   workspace_resource_id = module.loganalytics.id
#   workspace_name        = module.loganalytics.name
#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/ContainerInsights"
#   }
#   tags = {
#     CostCenter = "ABC000CBA"
#     By         = "parisamoosavinezhad@hotmail.com"
#   }
# }

# resource "azurerm_log_analytics_saved_search" "example" {
#   name                       = "exampleSavedSearch"
#   log_analytics_workspace_id = module.loganalytics.id

#   category     = "exampleCategory"
#   display_name = "exampleDisplayName"
#   query        = "Usage | where TimeGenerated > startofday(ago(31d))| where IsBillable == true | where TimeGenerated > startofday(ago(31d)) | where IsBillable == true | summarize BillableDataGB = sum(Quantity) / 1000. by bin(TimeGenerated, 1d), DataType | render barchart"
# }


# resource "azurerm_monitor_diagnostic_setting" "subscription" {
#   name                       = "example"
#   target_resource_id         = data.azurerm_subscription.current.id
#   log_analytics_workspace_id = module.loganalytics.id

#   log {
#     category = "Administrative"
#     enabled  = true

#     retention_policy {
#       days    = 10
#       enabled = true
#     }
#   }
#   log {
#     category = "Security"
#     enabled  = true

#     retention_policy {
#       days    = 10
#       enabled = true
#     }
#   }
#   log {
#     category = "ServiceHealth"
#     enabled  = true

#     retention_policy {
#       days    = 10
#       enabled = true
#     }
#   }
#   log {
#     category = "Alert"
#     enabled  = true

#     retention_policy {
#       days    = 10
#       enabled = true
#     }
#   }
#   log {
#     category = "Recommendation"
#     enabled  = true

#     retention_policy {
#       days    = 10
#       enabled = true
#     }
#   }
#   log {
#     category = "Policy"
#     enabled  = true

#     retention_policy {
#       days    = 10
#       enabled = true
#     }
#   }
#   log {
#     category = "Autoscale"
#     enabled  = true

#     retention_policy {
#       days    = 10
#       enabled = true
#     }
#   }
#   log {
#     category = "ResourceHealth"
#     enabled  = true

#     retention_policy {
#       days    = 10
#       enabled = true
#     }
#   }
# }



// https://docs.microsoft.com/en-us/azure/active-directory/reports-monitoring/howto-integrate-activity-logs-with-log-analytics
# resource "azurerm_monitor_aad_diagnostic_setting" "this" {
#   name                       = "aad-diaset"
#   log_analytics_workspace_id = module.loganalytics.id
#   log {
#     category = "SignInLogs"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "AuditLogs"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "NonInteractiveUserSignInLogs"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "ServicePrincipalSignInLogs"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "ManagedIdentitySignInLogs"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "ProvisioningLogs"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "ADFSSignInLogs"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "RiskyUsers"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "RiskyServicePrincipals"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "UserRiskEvents"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "ServicePrincipalRiskEvents"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
#   log {
#     category = "NetworkAccessTrafficLogs"
#     enabled  = true
#     retention_policy {
#       enabled = true
#       days    = 10
#     }
#   }
# }


#----------------------------------------------------------
# Azure Security Center Workspace Resource
#----------------------------------------------------------
# resource "azurerm_security_center_workspace" "this" {
#   scope        =  var.scope_resource_id == null ? data.azurerm_subscription.current.id : var.scope_resource_id
#   workspace_id = module.loganalytics.id
# }

#----------------------------------------------------------
# Azure Security Center Contact Resources
#----------------------------------------------------------
# resource "azurerm_security_center_contact" "this" {
#   email               = lookup(var.security_center_contacts, "email")
#   phone               = lookup(var.security_center_contacts, "phone", null)
#   alert_notifications = lookup(var.security_center_contacts, "alert_notifications", true)
#   alerts_to_admins    = lookup(var.security_center_contacts, "alerts_to_admins", true)
# }

# https://docs.microsoft.com/en-us/cli/azure/security/setting?view=azure-cli-latest#az-security-setting-update
# resource "azurerm_security_center_setting" "mcas" {
#   setting_name = "MCAS"
#   enabled      = false
# }

# resource "azurerm_security_center_setting" "wdatp" {
#   setting_name = "WDATP"
#   enabled      = false
# }

# resource "azurerm_log_analytics_solution" "Sentinel" {
#   solution_name         = "SecurityInsights"
#   location              = module.resourcegroup.location
#   resource_group_name   = module.resourcegroup.name
#   workspace_resource_id = amodule.loganalytics.id
#   workspace_name        = "monitoring-ws"

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/SecurityInsights"
#   }
# }

//------------------------------------------------------------------
// for activating one of the defender for cloud subscription
//
// https://msandbu.org/getting-started-with-azure-defender-and-azure-monitor-for-kubernetes-using-azure-arc/
//------------------------------------------------------------------
# resource "azurerm_security_center_subscription_pricing" "this" {
#   for_each      = toset(var.defender_plans)
#   tier          = "Standard"
#   resource_type = each.value
# }
