#!/usr/bin/env bash

set -x

bundle exec bashly generate

./cli 1
./cli 2
