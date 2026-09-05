# EVE-NG build inputs and provisioning steps.
variable "FILE_NAME" {
  type    = string
  default = "virtioa.qcow2"
}

variable "C8KV_IMG1_PATH" {
  type    = string
  default = "/opt/unetlab/addons/qemu/c8000v-17.15.06"
}

variable "C8KV_DL1_PATH" {
  type    = string
  default = "https://repo.dknetworks.io/files/c8kv_17.15/c8000v-universalk9_16G_serial.17.15.06.qcow2"
}

variable "PALO_IMG1_PATH" {
  type    = string
  default = "/opt/unetlab/addons/qemu/paloalto-10.2.5"
}

variable "PALO_DL1_PATH" {
  type    = string
  default = "https://repo.dknetworks.io/files/palo_10.2/virtioa.qcow2"
}

variable "PALO_IMG2_PATH" {
  type    = string
  default = "/opt/unetlab/addons/qemu/paloalto-11.2.10-h6"
}

variable "PALO_DL2_PATH" {
  type    = string
  default = "https://repo.dknetworks.io/files/palo_11.2/PA-VM-KVM-11.2.10-h6.qcow2"
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
      "mkdir -p /data/cisco1",
      "cd /data/cisco1",
      "pwd",
      "curl --fail --show-error --location --retry 5 --retry-delay 5 -o ${var.FILE_NAME} ${var.C8KV_DL1_PATH}",
      "echo 'Cisco image 1 downloaded'",
      "mkdir -p /data/palo1",
      "cd /data/palo1",
      "pwd",
      "curl --fail --show-error --location --retry 5 --retry-delay 5 -o ${var.FILE_NAME} ${var.PALO_DL1_PATH}",
      "echo 'Palo Alto image 1 downloaded'",
      "mkdir -p /data/palo2",
      "cd /data/palo2",
      "pwd",
      "curl --fail --show-error --location --retry 5 --retry-delay 5 -o ${var.FILE_NAME} ${var.PALO_DL2_PATH}",
      "echo 'Palo Alto image 2 downloaded'",
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
      "mkdir -p ${var.C8KV_IMG1_PATH}",
      "cd ${var.C8KV_IMG1_PATH}",
      "pwd",
      "mv /data/cisco1/${var.FILE_NAME} .",
      "ls",
      #
      "mkdir -p ${var.PALO_IMG1_PATH}",
      "cd ${var.PALO_IMG1_PATH}",
      "pwd",
      "mv /data/palo1/${var.FILE_NAME} .",
      "ls",
      #
      "mkdir -p ${var.PALO_IMG2_PATH}",
      "cd ${var.PALO_IMG2_PATH}",
      "pwd",
      "mv /data/palo2/${var.FILE_NAME} .",
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
