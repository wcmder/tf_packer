variable "FILE_ID" {
  type    = string
  default = "173AaRcZir8oMGrEXzdR2Zyd_KTIQJpg6"
}

variable "FILE_NAME" {
  type    = string
  default = "c8000v-universalk9.17.09.04a.iso"
}


build {
  sources = [
    "source.azure-arm.dev_arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt update",
      "apt -y upgrade"
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
      "pip install gdown",
      "mkdir -p /opt/unetlab/addons/qemu/c8000v-17.09.04a",
      "cd /opt/unetlab/addons/qemu/c8000v-17.09.04a",
      "gdown ${FILE_ID}"
      "qemu-img create -f qcow2 hda.qcow2 8G",
      "qemu-system-x86_64 -m 4096 -cdrom ${var.FILE_NAME} -hda hda.qcow2 -boot d -nographic",
      "rm ${var.FILE_NAME}",
      "/opt/unetlab/wrappers/unl_wrapper -a fixpermissions",
    ]
  }


  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}