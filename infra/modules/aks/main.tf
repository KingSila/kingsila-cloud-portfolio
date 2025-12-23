data "azurerm_client_config" "current" {}


resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version
  sku_tier           = var.sku_tier

  # Private cluster flag lives at the ROOT, not inside api_server_access_profile
  private_cluster_enabled = var.private_cluster_enabled

  tags = var.tags

  #############################################
  # Default node pool – simple & cheap
  #############################################
  default_node_pool {
    name           = "system"
    vm_size        = var.node_pool_vm_size
    node_count     = var.node_pool_node_count
    max_pods       = var.node_pool_max_pods
    vnet_subnet_id = var.aks_subnet_id
    type           = "VirtualMachineScaleSets"

    orchestrator_version = var.kubernetes_version

    upgrade_settings {
      max_surge = "33%"
    }

    tags = var.tags
  }

  #############################################
  # Identity
  #############################################
  identity {
    type = "SystemAssigned"
  }

  #############################################
  # Networking
  #############################################
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"

    dns_service_ip = "10.0.0.10"
    service_cidr   = "10.0.0.0/16"

    # docker_bridge_cidr REMOVED – your provider doesn't expect it
    # If needed later, we can add it back once we know the exact azurerm version.
  }

  #############################################
  # Azure AD / RBAC
  #############################################

  azure_active_directory_role_based_access_control {
    # Required by newer azurerm provider:
    # at least one of tenant_id or admin_group_object_ids
    tenant_id          = data.azurerm_client_config.current.tenant_id
    azure_rbac_enabled = var.enable_azure_rbac
  }

  #############################################
  # Workload Identity
  #############################################
  oidc_issuer_enabled       = var.workload_identity_enabled
  workload_identity_enabled = var.workload_identity_enabled

  #############################################
  # Lifecycle
  #############################################
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}
