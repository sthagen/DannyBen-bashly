# Argfile Example

Demonstrates how to autoload flag defaults from a file using the `argfile`
command option.

This example was generated with:

```bash
$ bashly init --minimal
# ... now edit src/bashly.yml to match the example ...
# ... now create .download to match the example ...
$ bashly generate
```

<!-- include: .download -->

-----

## `bashly.yml`

````yaml
name: download
help: Sample application with autoloaded arguments
version: 0.1.0

# Allow users to configure flag defaults in a file named '.download'
argfile: .download

args:
- name: source
  required: true
  help: URL to download from

flags:
- long: --force
  short: -f
  help: Overwrite existing files
- long: --log
  short: -l
  arg: path
  help: Path to log file

# Arguments in argfile also work for repeatable and unique flags
- long: --header
  short: -H
  arg: value
  repeatable: true
  unique: true
  help: Add an HTTP header
````

## `.download`

````bash
# Boolean flags in the argfile are loaded as defaults
--force

# Flag values must appear on the same line
--log "some path with spaces.log"

# Arguments in argfile also work for repeatable flags
--header "x-from-file: 1"

# Unknown flags in the argfile are ignored
--no-such-flag

# Non-flag lines in the argfile are ignored
this line is ignored

````


## Output

### `$ ./download --version`

````shell
0.1.0


````

### `$ ./download somesource`

````shell
# This file is located at 'src/root_command.sh'.
# It contains the implementation for the 'download' command.
# The code you write here will be wrapped by a function named 'root_command()'.
# Feel free to edit this file; your changes will persist when regenerating.
args:
- ${args[--force]} = 1
- ${args[--header]} = x-from-file:\ 1
- ${args[--log]} = some path with spaces.log
- ${args[source]} = somesource


````

### `$ ./download somesource --log cli.log`

````shell
# This file is located at 'src/root_command.sh'.
# It contains the implementation for the 'download' command.
# The code you write here will be wrapped by a function named 'root_command()'.
# Feel free to edit this file; your changes will persist when regenerating.
args:
- ${args[--force]} = 1
- ${args[--header]} = x-from-file:\ 1
- ${args[--log]} = cli.log
- ${args[source]} = somesource


````

### `$ ./download somesource --header "x-from-cli: 2"`

````shell
# This file is located at 'src/root_command.sh'.
# It contains the implementation for the 'download' command.
# The code you write here will be wrapped by a function named 'root_command()'.
# Feel free to edit this file; your changes will persist when regenerating.
args:
- ${args[--force]} = 1
- ${args[--header]} = x-from-file:\ 1 x-from-cli:\ 2
- ${args[--log]} = some path with spaces.log
- ${args[source]} = somesource


````

### `$ ./download somesource --header "x-from-file: 1"`

````shell
# This file is located at 'src/root_command.sh'.
# It contains the implementation for the 'download' command.
# The code you write here will be wrapped by a function named 'root_command()'.
# Feel free to edit this file; your changes will persist when regenerating.
args:
- ${args[--force]} = 1
- ${args[--header]} = x-from-file:\ 1
- ${args[--log]} = some path with spaces.log
- ${args[source]} = somesource


````



