terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

/*

This is needed in the consuming providers.tf file:

provider "proxmox" {
  pm_api_url = " "
  pm_api_token_id = " "
  pm_api_token_secret = " "
}

*/
