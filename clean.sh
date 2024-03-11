#!/bin/bash
rm -rf node_modules

yarn unlink "rdf-dataset-fragmenter"
yarn unlink "query-shape-detection"
yarn unlink "@comunica/config-query-sparql-link-traversal"
yarn unlink "@comunica/actor-context-preprocess-key-filter"
yarn unlink "@comunica/actor-extract-links-shape-index"
yarn unlink "@comunica/mediator-combine-array"
yarn unlink "@comunica/actor-rdf-resolve-hypermedia-links-queue-wrapper-filter-links"

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