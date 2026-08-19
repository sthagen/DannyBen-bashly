#!/usr/bin/env bash

set -x

bashly generate

### Try Me ###

./cli completions | head -n3
./cli __complete
./cli __complete download -
