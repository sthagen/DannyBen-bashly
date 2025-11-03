show_help=${args[--show-help-anyway]-}

if [[ $show_help ]]; then
  long_usage=yes
  cli_docker_usage
else
  inspect_args
fi
