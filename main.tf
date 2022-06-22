locals {
  product      = "monitoring"
  subscription = "dev"
  region_short = "we"
  environment  = "dev"
}

module "resourcegroup" {
  source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-resourcegroup?ref=main"
  # https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}
  region             = "westeurope"
  resource_long_name = "org-${local.product}"
  tags = {
    Service         = "network"
    AssetName       = "Asset Name"
    AssetID         = "AB00CD"
    BusinessUnit    = "Network Team"
    Confidentiality = "C1"
    Integrity       = "I1"
    Availability    = "A1"
    Criticality     = "Low"
    Owner           = "parisamoosavinezhad@hotmail.com"
    CostCenter      = ""
  }

}

module "loganalytics" {
  source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-log-analytics-workspace?ref=main"
  # https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}
  sku                     = "Free"
  retention_in_days       = 7
  resource_short_name     = local.product
  resource_group_name     = module.resourcegroup.name
  resource_group_location = module.resourcegroup.location
  tags = {
    Service         = "network"
    AssetName       = "Asset Name"
    AssetID         = "AB00CD"
    BusinessUnit    = "Network Team"
    Confidentiality = "C1"
    Integrity       = "I1"
    Availability    = "A1"
    Criticality     = "Low"
    Owner           = "parisamoosavinezhad@hotmail.com"
    CostCenter      = ""
  }

}