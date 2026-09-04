
# iPerf provisioning steps.
build {

  sources = [
    "source.azure-arm.dev_arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get update -y",
      "apt-get upgrade -y",
      "echo 'UPGRADE DONE'",
      "apt-get install -y iperf",
      "echo 'IPERF INSTALLED'",
      "apt-get install -y net-tools",
      "echo 'NET-TOOLS INSTALLED'",
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}
