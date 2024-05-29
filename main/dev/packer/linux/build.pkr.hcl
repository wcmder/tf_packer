variable "repo_ip" {
  type    = string
  default = "172.67.222.122"
}

variable "repo_fqdn" {
  type    = string
  default = "repo.dknetworks.io"
}

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
      "echo '${var.repo_ip} ${var.repo_fqdn}' | tee -a /etc/hosts",
      "mkdir -p /data/cisco",
      "cd /data/cisco",
      "pwd",
      "curl -k -sSL --retry 5 --retry-delay 5 -o ${var.FILE_NAME} ${var.C8KV_DL_PATH}",
      "echo 'downloaded'",
      "mkdir -p /data/palo",
      "cd /data/palo",
      "pwd",
      "curl -k -sSL --retry 5 --retry-delay 5 -o ${var.FILE_NAME} ${var.PALO_DL_PATH}",
      "echo 'downloaded'",
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
      "pwd",
      "mv /data/cisco/${var.FILE_NAME} .",
      "ls",
      #"/opt/unetlab/wrappers/unl_wrapper -a fixpermissions",
      #
      "mkdir -p ${var.PALO_IMG_PATH}",
      "cd ${var.PALO_IMG_PATH}",
      "pwd",
      "mv /data/palo/${var.FILE_NAME} .",
      "ls",
      #"/opt/unetlab/wrappers/unl_wrapper -a fixpermissions",
      #
      "echo 'ALL DONE - Images Installed'",
    ]
  }

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

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}