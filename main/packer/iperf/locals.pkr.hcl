# Derived iPerf image values.
locals {
  execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo /bin/bash {{ .Path }}"
}
