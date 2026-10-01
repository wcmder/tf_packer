
# iPerf provisioning steps.
build {

  sources = [
    "source.azure-arm.arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      # Command-not-found suggestions are optional; their metadata hook can fail
      # on missing CNF indexes and abort otherwise successful package updates.
      "if [ -f /etc/apt/apt.conf.d/50command-not-found ]; then mv /etc/apt/apt.conf.d/50command-not-found /etc/apt/50command-not-found.disabled; fi",
      # Log storage health and discard cached indexes that may be truncated.
      # Keep APT's lock file and signature verification intact.
      "df -h / /tmp /var/lib/apt/lists",
      "df -i / /tmp /var/lib/apt/lists",
      "ls -ld /tmp /var/lib/apt/lists /var/lib/apt/lists/partial",
      "find /var/lib/apt/lists -maxdepth 1 -type f -name '*InRelease' -exec wc -c {} +",
      "find /var/lib/apt/lists -type f ! -name lock -delete",
      "apt-get -o Acquire::Retries=3 -o APT::Update::Error-Mode=any update",
      # Ubuntu 22.04 ships iperf in Universe, which must be enabled explicitly.
      "apt-get install -y software-properties-common",
      "add-apt-repository --yes --no-update universe",
      "apt-get -o Acquire::Retries=3 -o APT::Update::Error-Mode=any update",
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
