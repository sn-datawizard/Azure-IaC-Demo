# Azure provider configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    databricks = {
      source = "databricks/databricks"
      version = "1.21.0"
    }    
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  host = var.DATABRICKS_HOST
}


# Create a resource group
resource "azurerm_resource_group" "amazingetl" {
  name     = "rg-amazingetl"
  location = "Germany West Central"
}


# Create a virtual network
resource "azurerm_virtual_network" "amazingetl_network" {
  name                = "vnet-amazingetl"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.amazingetl.location
  resource_group_name = azurerm_resource_group.amazingetl.name
}


/*
# Create event hub namespace and event hub
resource "azurerm_eventhub_namespace" "amazingetl_hubnamespace" {
  name                = "hubcontainer-amazingetl"
  location            = azurerm_resource_group.amazingetl.location
  resource_group_name = azurerm_resource_group.amazingetl.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = "Development"
  }
}

resource "azurerm_eventhub" "amazingetl_hub" {
  name                = "hubevent-amazingetl"
  namespace_name      = azurerm_eventhub_namespace.amazingetl_hubnamespace.name
  resource_group_name = azurerm_resource_group.amazingetl.name
  partition_count     = 2
  message_retention   = 1
}
*/


# Create storage account and data lake gen2
resource "azurerm_storage_account" "amazingetl_storageaccount" {
  name                     = "storageacc1amazingetl"
  resource_group_name      = azurerm_resource_group.amazingetl.name
  location                 = azurerm_resource_group.amazingetl.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "amazingetl-datalake-bronze" {
  name               = "bronze-dlscontainer-amazingetl"
  storage_account_id = azurerm_storage_account.amazingetl_storageaccount.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "amazingetl-datalake-silver" {
  name               = "silver-dlscontainer-amazingetl"
  storage_account_id = azurerm_storage_account.amazingetl_storageaccount.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "amazingetl-datalake-gold" {
  name               = "gold-dlscontainer-amazingetl"
  storage_account_id = azurerm_storage_account.amazingetl_storageaccount.id
}


/*
# Create Azure Databricks workspace
resource "azurerm_databricks_workspace" "amazingetl-databricks" {
  name                = "bricksworkspace-amazingetl"
  resource_group_name = azurerm_resource_group.amazingetl.name
  location            = azurerm_resource_group.amazingetl.location
  sku                 = "standard"

  tags = {
    Environment = "Development"
  }
}

# Create Databricks cluster
data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "amazingetl-databrickscluster" {
  cluster_name            = "brickscluster-amazingetl"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 8
  }
}
*/

