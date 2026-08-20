module "resource_group" {
    source = "../../modules/azurerm_rg"
  rgs = var.rgs
}