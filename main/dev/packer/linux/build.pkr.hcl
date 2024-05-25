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
      "mkdir -p /opt/unetlab/addons/qemu/c8000v-17.06.01",
      "cd /opt/unetlab/addons/qemu/c8000v-17.06.01",
      "wget http://repo.dknetworks.io/files/c8000v-universalk9.17.09.04a.iso",
      "qemu-img create -f qcow2 hda.qcow2 8G",
      "qemu-system-x86_64 -m 4096 -cdrom c8000v-universalk9.17.09.04a.iso -hda hda.qcow2 -boot d -nographic",
      "rm c8000v-universalk9.17.09.04a.iso",
      "/opt/unetlab/wrappers/unl_wrapper -a fixpermissions"
    ]
  }


  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}