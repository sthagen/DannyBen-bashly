if [[ "${other_args[0]}" == "show-hidden-usage" ]]; then
  long_usage=yes
  cli_docker_usage
else
  inspect_args
fi
