#!/bin/bash
pushd index-vs-storage
yarn install --ignore-engines
yarn link "@jbr-experiment/solidbench"
popd

pushd queries-short
yarn install --ignore-engines
yarn link "@jbr-experiment/solidbench"
popd

pushd queries-discover
yarn install --ignore-engines
yarn link "@jbr-experiment/solidbench"
popd

pushd queries-complex
yarn install --ignore-engines
yarn link "@jbr-experiment/solidbench"
popd

pushd fragmentation
yarn install --ignore-engines
yarn link "@jbr-experiment/solidbench"
popd
