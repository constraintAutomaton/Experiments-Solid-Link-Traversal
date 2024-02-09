#!/bin/bash
pushd index-vs-storage
yarn install
popd

pushd queries-short
yarn install
popd

pushd queries-discover
yarn install
popd

pushd queries-complex
yarn install
popd

pushd fragmentation
yarn install
popd
