#!/usr/bin/env bash

rm -f ./download
rm -f ./src/*.sh

bundle exec bashly generate

set -x

./download somesource
DOWNLOAD_ARGFILE=off ./download somesource
DOWNLOAD_ARGFILE=.alt-download ./download somesource
