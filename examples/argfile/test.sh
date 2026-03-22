#!/usr/bin/env bash

rm -f ./download

set -x

bashly generate

### Try Me ###

./download somesource
./download somesource --log cli.log
