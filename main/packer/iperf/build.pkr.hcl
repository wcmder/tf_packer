
# iPerf provisioning steps.
build {

  sources = [
    "source.azure-arm.arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get -o APT::Update::Error-Mode=any update",
      # Ubuntu 22.04 ships iperf in Universe, which must be enabled explicitly.
      "apt-get install -y software-properties-common",
      "add-apt-repository --yes --no-update universe",
      "apt-get -o APT::Update::Error-Mode=any update",
      "apt-get upgrade -y",
      "echo 'UPGRADE DONE'",
      "apt-get install -y iperf",
      "iperf --version",
      "echo 'IPERF INSTALLED'",
      "apt-get install -y net-tools",
      "echo 'NET-TOOLS INSTALLED'",
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm.arm"]
  }

}
