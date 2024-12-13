
build {

  sources = [
    "source.azure-arm.dev_arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt update -y",
      "apt upgrade -y",
      "echo 'UPGRADE DONE'",
      "apt install -y iperf",
      "echo 'IPERF INSTALLED'",
      "apt install net-tools",
      "echo 'NET-TOOLS INSTALLED'",
    ]
  }

}