#!/bin/bash
rm -rf node_modules

pushd experiments

pushd index-vs-storage
rm -f yarn.lock
rm -rf node_modules
rm -r generated/*
rm -r combinations/*
popd

pushd queries-short
rm -f yarn.lock
rm -rf node_modules
rm -r generated/*
rm -r combinations/*
popd

pushd queries-discover
rm -f yarn.lock
rm -rf node_modules
rm -r generated/*
rm -r combinations/*
popd

pushd queries-complex
rm -f yarn.lock
rm -rf node_modules
rm -r generated/*
rm -r combinations/*
popd

pushd fragmentation
rm -f yarn.lock
rm -rf node_modules
rm -r generated/*
rm -r combinations/*
popd

popd