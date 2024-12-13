
build {

  sources = [
    "source.azure-arm.dev_arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get update -y",
      "apt-get install -y iperf",
      "echo 'IPERF installed'",
    ]
  }

}