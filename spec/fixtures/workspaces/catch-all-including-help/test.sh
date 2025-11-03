#!/usr/bin/env bash

rm -f ./cli

set -x

bundle exec bashly generate

./cli docker --help
./cli docker --show-help-anyway
