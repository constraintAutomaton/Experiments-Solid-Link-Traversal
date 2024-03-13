#!/bin/bash
yarn install --ignore-engines
pushd rdf-dataset-fragmenter.js
    # might return an error but it is still compiling
    yarn build:components
    yarn build:ts
popd