build {
  sources = [
    "source.azure-arm.dev_arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt update",
      "apt upgrade"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      #"wget -O - https : //www.eve-ng.net/focal/install-eve.sh | bash -i",
      "curl -k -sSL https://www.eve-ng.net/focal/install-eve.sh | bash -i"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}