variable "C8KV_FILE_ID" {
  type    = string
  default = "173AaRcZir8oMGrEXzdR2Zyd_KTIQJpg6"
}

variable "C8KV_FILE_NAME" {
  type    = string
  default = "c8000v-universalk9.17.09.04a.iso"
}

variable "C8KV_PATH" {
  type    = string
  default = "/opt/unetlab/addons/qemu/c8000v-17.09.04a"
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
    execute_command = local.execute_command
    inline = [
      "apt update",
      "apt -y install python3-pip",
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "pip3 install gdown --quiet",
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
      "mkdir -p ${var.C8KV_PATH}",
      "cd ${var.C8KV_PATH}",
      "gdown ${var.C8KV_FILE_ID}",
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cd ${var.C8KV_PATH}",
      "qemu-img create -f qcow2 hda.qcow2 8G",
      "qemu-system-x86_64 -m 4096 -cdrom ${var.C8KV_FILE_NAME} -hda hda.qcow2 -boot d -nographic",
      "rm ${var.C8KV_FILE_NAME}",
      "/opt/unetlab/wrappers/unl_wrapper -a fixpermissions",
    ]
  }


  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}