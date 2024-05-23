locals {
  #execute_command = "chmod +x {{ .Path }}; {{ .Var }} sudo -E sh '{{ .Path }}'"
  execute_command = "chmod +x {{ .Path }}; sudo -E sh '{{ .Var }} {{ .Path }}'"
}