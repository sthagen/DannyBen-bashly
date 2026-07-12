#!/usr/bin/env bash

rm -f ./colorize
rm -f ./src/*.sh

bundle exec bashly generate

set -x

./colorize
./colorize --no-color
ARGFILE=.colorize-off ./colorize
ARGFILE=.colorize-off ./colorize --color
