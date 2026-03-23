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
````

## `.download`

````bash
--force
--log "some path with spaces.log"

````

Only flag lines are loaded from the argfile. Each flag value must appear on the
same line as the flag. Non-flag lines are ignored.


## Output

### `$ ./download somesource`

````shell
# This file is located at 'src/root_command.sh'.
# It contains the implementation for the 'download' command.
# The code you write here will be wrapped by a function named 'root_command()'.
# Feel free to edit this file; your changes will persist when regenerating.
args:
- ${args[--force]} = 1
- ${args[--log]} = some path with spaces.log
- ${args[source]} = somesource


````

### `$ ./download --help`

````shell
download - Sample application with autoloaded arguments

Usage:
  download SOURCE [OPTIONS]
  download --help | -h
  download --version | -v
````

### `$ ./download somesource --log cli.log`

````shell
# This file is located at 'src/root_command.sh'.
# It contains the implementation for the 'download' command.
# The code you write here will be wrapped by a function named 'root_command()'.
# Feel free to edit this file; your changes will persist when regenerating.
args:
- ${args[--force]} = 1
- ${args[--log]} = cli.log
- ${args[source]} = somesource


````


