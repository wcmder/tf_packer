locals {
  execute_command = "chmod +x {{ .Path }}; {{ .Var }} sudo -E bash '{{ .Path }}'"
}