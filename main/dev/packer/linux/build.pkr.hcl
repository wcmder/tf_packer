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
    execute_command = local.execute_command
    inline = [
      "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A0E4A1A5",
      "echo 'deb [arch=amd64] http://www.eve-ng.net/focal focal main' | sudo tee /etc/apt/sources.list.d/eve-ng.list",
      "apt update",
      "curl -k -sSL https://www.eve-ng.net/focal/install-eve.sh | bash -i"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}