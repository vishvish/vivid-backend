#!/bin/bash

set -e -x

pushd vivid-backend-src
  bundle install
  bundle exec rspec
popd
