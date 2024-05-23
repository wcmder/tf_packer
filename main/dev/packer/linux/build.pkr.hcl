build {
  sources = [
    "source.azure-arm.dev_arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt update",
      #"apt -y upgrade"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      #"curl -o /etc/apt/trusted.gpg.d/eve-ng-key2.gpg https://www.eve-ng.net/focal/dists/focal/Release.gpg",
      #"echo 'deb [arch=amd64] http://www.eve-ng.net/focal focal main' | sudo tee /etc/apt/sources.list.d/eve-ng.list",
      #"apt update",
      "curl -k -sSL https://www.eve-ng.net/jammy/install-eve.sh | bash -i"
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}