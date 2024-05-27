variable "C8KV_FILE_NAME" {
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


variable "PALO_FILE_NAME" {
  type    = string
  default = "virtioa.qcow2"
}

variable "PALO_IMG_PATH" {
  type    = string
  default = "/opt/unetlab/addons/qemu/paloalto-10.2.5"
}

variable "PALO_DL_PATH" {
  type    = string
  default = "https://repo.dknetworks.io/files/palo/virtioa.qcow2"
}



build {
  sources = [
    "source.azure-arm.dev_arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt update",
      "apt -y upgrade",
    ]
  }

  provisioner "shell" {
    execute_command   = local.execute_command
    expect_disconnect = true
    inline = [
      "curl -k -sSL https://www.eve-ng.net/jammy/install-eve.sh | bash -i",
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "mkdir -p ${var.C8KV_IMG_PATH}",
      "cd ${var.C8KV_IMG_PATH}",
      "curl -k -sSL -o ${var.C8KV_FILE_NAME} ${var.C8KV_DL_PATH}",
      "/opt/unetlab/wrappers/unl_wrapper -a fixpermissions",
    ]
  }


  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "mkdir -p ${var.PALO_IMG_PATH}",
      "cd ${var.PALO_IMG_PATH}",
      "curl -k -sSL -o ${var.PALO_FILE_NAME} ${var.PALO_DL_PATH}",
      "/opt/unetlab/wrappers/unl_wrapper -a fixpermissions",
    ]
  }


  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}