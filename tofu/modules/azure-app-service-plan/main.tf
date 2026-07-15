resource "azurerm_service_plan" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.kind == "Linux" || var.kind == "linux" ? "Linux" : "Windows"
  sku_name            = var.sku.size
  worker_count        = var.sku.capacity

  tags = var.tags
}



