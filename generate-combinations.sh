#!/bin/bash
pushd experiments

pushd queries-short
cp -rf ../../config-client input/config-client
yarn jbr generate-combinations
popd

pushd queries-discover
cp -rf ../../config-client input/config-client
yarn jbr generate-combinations
popd

pushd queries-complex
cp -rf ../../config-client input/config-client
yarn jbr generate-combinations
popd

pushd fragmentation
cp -rf ../../config-client input/config-client
yarn jbr generate-combinations
popd

popd
