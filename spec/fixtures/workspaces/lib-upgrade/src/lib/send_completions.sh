## [@bashly-upgrade completions send_completions]
send_completions() {
  echo $'# cli completion                                           -*- shell-script -*-'
  echo $''
  echo $'# This bash completions script was generated by'
  echo $'# completely (https://github.com/dannyben/completely)'
  echo $'# Modifying it manually is not recommended'
  echo $''
  echo $'_cli_completions_filter() {'
  echo $'  local words="$1"'
  echo $'  local cur=${COMP_WORDS[COMP_CWORD]}'
  echo $'  local result=()'
  echo $''
  echo $'  if [[ "${cur:0:1}" == "-" ]]; then'
  echo $'    echo "$words"'
  echo $''
  echo $'  else'
  echo $'    for word in $words; do'
  echo $'      [[ "${word:0:1}" != "-" ]] && result+=("$word")'
  echo $'    done'
  echo $''
  echo $'    echo "${result[*]}"'
  echo $''
  echo $'  fi'
  echo $'}'
  echo $''
  echo $'_cli_completions() {'
  echo $'  local cur=${COMP_WORDS[COMP_CWORD]}'
  echo $'  local compwords=("${COMP_WORDS[@]:1:$COMP_CWORD-1}")'
  echo $'  local compline="${compwords[*]}"'
  echo $''
  echo $'  case "$compline" in'
  echo $'    \'download\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cli_completions_filter "--force --help -f -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'upload\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cli_completions_filter "--help --password --user -h -p -u")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'d\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cli_completions_filter "--force --help -f -h")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    \'u\'*)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cli_completions_filter "--help --password --user -h -p -u")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'    *)'
  echo $'      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_cli_completions_filter "--help --version -h -v d download u upload")" -- "$cur")'
  echo $'      ;;'
  echo $''
  echo $'  esac'
  echo $'} &&'
  echo $'  complete -F _cli_completions cli'
  echo $''
  echo $'# ex: filetype=sh'
}