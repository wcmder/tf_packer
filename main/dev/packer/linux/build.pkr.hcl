variable "FILE_ID" {
  type    = string
  default = "173AaRcZir8oMGrEXzdR2Zyd_KTIQJpg6",
}

variable "FILE_NAME" {
  type    = string
  default = "c8000v-universalk9.17.09.04a.iso",
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
      "mkdir -p /opt/unetlab/addons/qemu/c8000v-17.09.04a",
      "cd /opt/unetlab/addons/qemu/c8000v-17.09.04a",
      "CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate https://drive.google.com/uc?export=download&id=${FILE_ID} -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\\1/p')",
      "wget --load-cookies /tmp/cookies.txt https://drive.google.com/uc?export=download&confirm=$CONFIRM&id=${FILE_ID} -O ${FILE_NAME} && rm -rf /tmp/cookies.txt",
      "qemu-img create -f qcow2 hda.qcow2 8G",
      "qemu-system-x86_64 -m 4096 -cdrom ${FILE_NAME} -hda hda.qcow2 -boot d -nographic",
      "rm ${FILE_NAME}",
      "/opt/unetlab/wrappers/unl_wrapper -a fixpermissions",
    ]
  }


  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}