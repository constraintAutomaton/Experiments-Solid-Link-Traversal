#!/bin/bash
pushd experiments

pushd index-vs-storage
yarn jbr generate-combinations
popd

pushd queries-short
yarn jbr generate-combinations
popd

pushd queries-discover
yarn jbr generate-combinations
popd

pushd queries-complex
yarn jbr generate-combinations
popd

pushd fragmentation
yarn jbr generate-combinations
popd

popd
