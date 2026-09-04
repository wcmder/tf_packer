# Required Packer plugins.
packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "= 2.6.3"
    }
  }
}
