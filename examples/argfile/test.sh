#!/usr/bin/env bash

rm -f ./download

set -x

bashly generate

### Try Me ###

./download --version
./download somesource
./download somesource --log cli.log
./download somesource --header "x-from-cli: 2"

# demonstrating uniqueness across command line and argfile
./download somesource --header "x-from-file: 1"
