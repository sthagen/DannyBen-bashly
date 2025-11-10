# Multiple Lib Dirs

Demonstrates how to include more than one lib directories in the generated
script.

This example was generated with:

```bash
$ bashly init --minimal
$ bashly add settings
# ... now edit settings.yml to match the example ...
$ bashly generate
# ... now edit src/root_command.sh to match the example ...
$ bashly generate
```

<!-- include: settings.yml src/root_command.sh -->

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

## `settings.yml`

````yaml
# An array or comma delimited string of additional directories to search for
# bash functions. Any bash script found in any of these directories
# (or sub-directories) will be merged into the final script.
# Note that this is relative to the working directory.
extra_lib_dirs: [common_lib, cloud_lib]

````

## `src/root_command.sh`

````bash
# Calling library functions
common_function
cloud_function
````


## Output

### `$ ./download some_source`

````shell
common_function called
cloud_function called


````



