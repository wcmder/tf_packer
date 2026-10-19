# EVE-NG build inputs and provisioning steps.
variable "FILE_NAME" {
  type    = string
  default = "virtioa.qcow2"
}

variable "EVE_IMAGES" {
  type = map(object({
    image_path    = string
    download_path = string
  }))

  default = {
    c8kv_17_15 = {
      image_path    = "/opt/unetlab/addons/qemu/c8000v-17.15.06"
      download_path = "https://repo.dknetworks.io/files/c8kv_17.15/c8000v-universalk9_16G_serial.17.15.06.qcow2"
    }
    versadir_22_1_4 = {
      image_path    = "/opt/unetlab/addons/qemu/versadir-22.1.4"
      download_path = "https://repo.dknetworks.io/files/versa_22.1/versa-director-d58d641-22.1.4-B.qcow2"
    }
    versaana_22_1_4 = {
      image_path    = "/opt/unetlab/addons/qemu/versaana-22.1.4"
      download_path = "https://repo.dknetworks.io/files/versa_22.1/versa-analytics-262aa66-22.1.4-B.qcow2"
    }
    versafvnf_22_1_4 = {
      image_path    = "/opt/unetlab/addons/qemu/versafvnf-22.1.4"
      download_path = "https://repo.dknetworks.io/files/versa_22.1/versa-flexvnf-262aa66-22.1.4-B.qcow2"
    }
    pano_12_1 = {
      image_path    = "/opt/unetlab/addons/qemu/panorama-12.1.2"
      download_path = "https://repo.dknetworks.io/files/palo_12.1/Panorama-KVM-12.1.2.qcow2"
    }
    palo_12_1 = {
      image_path    = "/opt/unetlab/addons/qemu/paloalto-12.1.7"
      download_path = "https://repo.dknetworks.io/files/palo_12.1/PA-VM-KVM-12.1.7.qcow2"
    }
  }
}

locals {
  eve_installer_url    = "https://www.eve-ng.net/jammy/install-eve.sh"
  eve_installer_sha256 = "5c2139837cc8de6d270439d7564040fdfd151522ff03fc7dbd39586c82dbaa6d"

  download_image_commands = flatten([
    for name, image in var.EVE_IMAGES : [
      "mkdir -p /data/${name}",
      "cd /data/${name}",
      "pwd",
      # Start a fresh curl process for each attempt so the resume offset includes
      # bytes received before a connection reset. Built-in retries rewind output.
      <<-EOT
      for attempt in 1 2 3 4 5 6; do
        echo "Downloading ${name}: attempt $attempt/6"
        if curl --fail --show-error --location --connect-timeout 30 --continue-at - -o '${var.FILE_NAME}' '${image.download_path}'; then
          break
        else
          status=$?
        fi
        if [ "$attempt" -eq 6 ] || [ "$status" -eq 33 ]; then
          echo "Download failed for ${name} (curl exit $status)" >&2
          exit "$status"
        fi
        echo "Retrying ${name} from the partial file in 5 seconds"
        sleep 5
      done
      EOT
      ,
      "echo '${name} image downloaded'",
    ]
  ])

  install_image_commands = flatten([
    for name, image in var.EVE_IMAGES : [
      "mkdir -p ${image.image_path}",
      "cd ${image.image_path}",
      "pwd",
      "mv /data/${name}/${var.FILE_NAME} .",
      "ls -lh ${var.FILE_NAME}",
    ]
  ])
}



build {
  sources = [
    "source.azure-arm.arm"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      # Command-not-found suggestions are optional; their metadata hook can fail
      # on missing CNF indexes and abort otherwise successful package updates.
      "if [ -f /etc/apt/apt.conf.d/50command-not-found ]; then mv /etc/apt/apt.conf.d/50command-not-found /etc/apt/50command-not-found.disabled; fi",
      "apt-get update",
      "apt-get -y upgrade",
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = local.download_image_commands
  }


  provisioner "shell" {
    execute_command   = local.execute_command
    expect_disconnect = true
    inline = [
      "curl --fail --show-error --location --retry 5 --retry-delay 5 -o /tmp/install-eve.sh ${local.eve_installer_url}",
      "echo '${local.eve_installer_sha256}  /tmp/install-eve.sh' | sha256sum --check --strict",
      "bash -i /tmp/install-eve.sh",
      "rm -f /tmp/install-eve.sh",
    ]
  }

  provisioner "shell" {
    execute_command   = local.execute_command
    expect_disconnect = true
    pause_after       = "120s"
    inline = concat(local.install_image_commands, [
      "echo 'root:eve' | sudo chpasswd",
      "echo 'DONE - root set, images installed, rebooting'",
      "reboot now",
    ])
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "echo 'fix permissions'",
      "/opt/unetlab/wrappers/unl_wrapper -a fixpermissions",
      "echo 'DONE - permission set'",
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    script          = "${path.root}/scripts/configure-pnet1.sh"
  }

  provisioner "shell" {
    execute_command = local.execute_command
    script          = "${path.root}/scripts/configure-routing.sh"
  }

  provisioner "shell" {
    execute_command = local.execute_command
    script          = "${path.root}/scripts/configure-dhcp.sh"
  }

  /*
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt update",
      "echo 'installing xrdp'",
      "apt install xrdp -y",
    ]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt update",
      "echo 'installing desktop'",
      "apt install ubuntu-desktop -y",
    ]
  }
  */

  provisioner "shell" {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm"]
  }

}
