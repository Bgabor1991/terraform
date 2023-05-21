provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Learning-terraform" {
  name     = "Learning-terraform"
  location = "UK South"
}

resource "azurerm_virtual_network" "main-vnet" {
  name                = "main-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Learning-terraform.location
  resource_group_name = azurerm_resource_group.Learning-terraform.name
}

resource "azurerm_subnet" "main-subnet1" {
  name                 = "main-subnet1"
  resource_group_name  = azurerm_resource_group.Learning-terraform.name
  virtual_network_name = azurerm_virtual_network.main-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "terraform-vm1-nic" {
  name                = "terraform-vm1-nic"
  location            = azurerm_resource_group.Learning-terraform.location
  resource_group_name = azurerm_resource_group.Learning-terraform.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main-subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "terraform-vm1" {
  name                = "terraform-vm1"
  resource_group_name = azurerm_resource_group.Learning-terraform.name
  location            = azurerm_resource_group.Learning-terraform.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.terraform-vm1-nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_5-gen2"
    version   = "latest"
}
}
