#!/bin/bash
rm -rf node_modules

pushd experiments

pushd queries-short
rm -rf node_modules
rm -r generated/*
rm -r combinations/*
popd

pushd queries-discover
rm -rf node_modules
rm -r generated/*
rm -r combinations/*
popd

pushd queries-complex
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