# Runtime Completions Example

Demonstrates how to expose the generated `send_completions` function through
an application command. Runtime completions are enabled in `settings.yml`.

Users can load the Bash wrapper with:

```bash
source <(cli completions)
```

This example was generated with:

```bash
$ bashly init
# ... now edit src/bashly.yml to match the example ...
# ... now edit settings.yml to match the example ...
$ bashly generate
# ... now edit completions_command.sh to match the example ...
$ bashly generate
```

<!-- include: settings.yml src/completions_command.sh -->

-----

## `bashly.yml`

````yaml
name: cli
help: Runtime completions example
version: 0.1.0

commands:
- name: completions
  help: Generate a shell completion script
  args:
  - name: shell
    help: Shell to generate completions for
    allowed: [bash]
    default: bash

- name: download
  help: Download a file
  args:
  - name: source
    help: URL to download
    required: true
  flags:
  - long: --force
    short: -f
    help: Overwrite an existing file
````

## `settings.yml`

````yaml
enable_completions: always

````

## `src/completions_command.sh`

````bash
send_completions "${args[shell]}"

````


## Output

### `$ ./cli completions | head -n3`

````shell
_cli_completions() {
  local completion_command="${COMP_WORDS[0]}"
  local completion_current="${COMP_WORDS[COMP_CWORD]:-}"


````

### `$ ./cli __complete`

````shell
completions
download


````

### `$ ./cli __complete download -`

````shell
--help
-h
--force
-f


````



