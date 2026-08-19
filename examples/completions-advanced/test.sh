#!/usr/bin/env bash

set -x

bashly generate

### Try Me ###

./cli completions | head -n3
./cli __complete ""
./cli __complete deploy main st
./cli __complete deploy --config ""
./cli __complete deploy --directory ""
