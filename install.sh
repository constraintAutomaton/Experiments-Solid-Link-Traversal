#!/bin/bash
yarn install --ignore-engines
pushd engine
    ./build_docker.sh
popd