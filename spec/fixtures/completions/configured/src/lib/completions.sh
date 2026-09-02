completion_colors() {
  printf 'red\ngreen\nblue\n'
}

completion_failure() {
  printf 'partial\n'
  printf 'completion failed\n' >&2
  return 1
}
