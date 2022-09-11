variable "scope_resource_id" {
  type    = string
  default = null
}

variable "security_center_contacts" {
  type        = map(string)
  description = "Manages the subscription's Security Center Contact"
  default = {
    "email"               = "test@test.com",
    "phone"               = null,
    "alert_notifications" = false,
    "alerts_to_admins"    = false
  }
}

variable "defender_plans" {
  type    = list(string)
  default = ["Arm", "Dns", "AppServices", "StorageAccounts"]
}

//------------------------------------------------
//    for naming
//------------------------------------------------
variable "location" {
  type    = string
  default = "germanywestcentral"
}

variable "prefix" {
  type    = string
  default = "projn"
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "name" {
  type    = string
  default = "monitoring"
}

variable "location_shortname" {
  type    = string
  default = "gwc"
}