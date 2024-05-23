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
      "curl -o curl -o /tmp/eczema@ecze.com.gpg.key https://www.eve-ng.net/focal/eczema@ecze.com.gpg.key",
      "gpg --dearmor /tmp/eczema@ecze.com.gpg.key > /etc/apt/trusted.gpg.d/eve-ng-key1.gpg",
      "curl -o curl -o /tmp/dev@eve-ng.net.gpg.key https://www.eve-ng.net/focal/dev@eve-ng.net.gpg.key",
      "gpg --dearmor /tmp/dev@eve-ng.net.gpg.key > /etc/apt/trusted.gpg.d/eve-ng-key2.gpg",
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