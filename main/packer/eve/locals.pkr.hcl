# Derived EVE-NG image values.
locals {
  execute_command = "chmod +x {{ .Path }} && {{ .Vars }} sudo /bin/bash -e -o pipefail {{ .Path }}"
}
