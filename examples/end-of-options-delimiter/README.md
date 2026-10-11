# End-of-Options Delimiter Example

Demonstrates how `--` marks the end of options, allowing subsequent values that
start with `-` to be parsed as positional arguments.

This example was generated with:

```bash
$ bashly init --minimal
$ bashly generate
```

-----

## `bashly.yml`

````yaml
name: download
help: Sample minimal application without commands
version: 0.1.0

args:
- name: source
  required: true
  help: URL to download from
- name: target
  help: "Target filename (default: same as source)"

flags:
- long: --force
  short: -f
  help: Overwrite existing files

examples:
- download example.com
- download example.com ./output -f
````



## Output

### `$ ./download`

````shell
missing required argument: SOURCE
usage: download SOURCE [TARGET] [OPTIONS]


````

### `$ ./download -h`

````shell
download - Sample minimal application without commands

Usage:
  download SOURCE [TARGET] [OPTIONS]
  download --help | -h
  download --version | -v

Options:
  --force, -f
    Overwrite existing files

  --help, -h
    Show this help

  --version, -v
    Show version number

Arguments:
  SOURCE
    URL to download from

  TARGET
    Target filename (default: same as source)

Examples:
  download example.com
  download example.com ./output -f



````

### `$ ./download --force -- -source.txt -target.txt`

````shell
# This file is located at 'src/root_command.sh'.
# It contains the implementation for the 'download' command.
# The code you write here will be wrapped by a function named 'root_command()'.
# Feel free to edit this file; your changes will persist when regenerating.
args:
- ${args[--force]} = 1
- ${args[source]} = -source.txt
- ${args[target]} = -target.txt


````


