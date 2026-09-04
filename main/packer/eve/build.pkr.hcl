# EVE-NG build inputs and provisioning steps.
variable "FILE_NAME" {
  type    = string
  default = "virtioa.qcow2"
}

variable "C8KV_IMG_PATH" {
  type    = string
  default = "/opt/unetlab/addons/qemu/c8000v-17.06.02"
}

variable "C8KV_DL_PATH" {
  type    = string
  default = "https://repo.dknetworks.io/files/c8kv/virtioa.qcow2"
}

variable "PALO_IMG_PATH" {
  type    = string
  default = "/opt/unetlab/addons/qemu/paloalto-10.2.5"
}

variable "PALO_DL_PATH" {
  type    = string
  default = "https://repo.dknetworks.io/files/palo/virtioa.qcow2"
}

locals {
  eve_installer_url    = "https://www.eve-ng.net/jammy/install-eve.sh"
  eve_installer_sha256 = "5c2139837cc8de6d270439d7564040fdfd151522ff03fc7dbd39586c82dbaa6d"
}



build {
  sources = [
    "source.azure-arm.dev_arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt -y update",
      "apt -y upgrade",
    ]
  }

  provisioner "shell" {
    execute_command   = local.execute_command
    expect_disconnect = true
    inline = [
      "mkdir -p /data/cisco",
      "cd /data/cisco",
      "pwd",
      "curl --fail --show-error --location --retry 5 --retry-delay 5 -o ${var.FILE_NAME} ${var.C8KV_DL_PATH}",
      "echo 'Cisco image downloaded'",
      "mkdir -p /data/palo",
      "cd /data/palo",
      "pwd",
      "curl --fail --show-error --location --retry 5 --retry-delay 5 -o ${var.FILE_NAME} ${var.PALO_DL_PATH}",
      "echo 'Palo Alto image downloaded'",
    ]
  }


  provisioner "shell" {
    execute_command   = local.execute_command
    expect_disconnect = true
    inline = [
      "curl --fail --show-error --location --retry 5 --retry-delay 5 -o /tmp/install-eve.sh ${local.eve_installer_url}",
      "echo '${local.eve_installer_sha256}  /tmp/install-eve.sh' | sha256sum --check --strict",
      "bash -i /tmp/install-eve.sh",
      "rm -f /tmp/install-eve.sh",
    ]
  }

  provisioner "shell" {
    execute_command   = local.execute_command
    expect_disconnect = true
    pause_after       = "120s"
    inline = [
      "mkdir -p ${var.C8KV_IMG_PATH}",
      "cd ${var.C8KV_IMG_PATH}",
      "pwd",
      "mv /data/cisco/${var.FILE_NAME} .",
      "ls",
      #
      "mkdir -p ${var.PALO_IMG_PATH}",
      "cd ${var.PALO_IMG_PATH}",
      "pwd",
      "mv /data/palo/${var.FILE_NAME} .",
      "ls",
      #
      "echo 'root:eve' | sudo chpasswd",
      "echo 'DONE - root set, images installed, rebooting'",
      "reboot now",
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "echo 'fix permissions'",
      "/opt/unetlab/wrappers/unl_wrapper -a fixpermissions",
      "echo 'DONE - permission set'",
    ]
  }

  /*
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt update",
      "echo 'installing xrdp'",
      "apt install xrdp -y",
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt update",
      "echo 'installing desktop'",
      "apt install ubuntu-desktop -y",
    ]
  }
  */

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}
