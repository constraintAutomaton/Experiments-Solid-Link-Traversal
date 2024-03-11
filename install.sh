#!/bin/bash

pushd rdf-dataset-fragmenter.js
yarn install --ignore-engines
yarn build
yarn link
popd

pushd query-shape-detection
yarn install --ignore-engines
yarn build
yarn link
popd

pushd comunica-feature-link-traversal
    yarn link "query-shape-detection"
    yarn install
    pushd engines
        pushd config-query-sparql-link-traversal
        yarn link
        popd

    popd
        pushd packages
            pushd actor-context-preprocess-key-filter
                yarn link
            popd
            pushd actor-extract-links-shape-index
                yarn link
            popd
            pushd mediator-combine-array
                yarn link
            popd
            pushd actor-rdf-resolve-hypermedia-links-queue-wrapper-filter-links
                yarn link
            popd

        popd
    popd
popd

yarn install --ignore-engines

yarn link "rdf-dataset-fragmenter"
yarn link "query-shape-detection"
yarn link "@comunica/config-query-sparql-link-traversal"
yarn link "@comunica/actor-context-preprocess-key-filter"
yarn link "@comunica/actor-extract-links-shape-index"
yarn link "@comunica/mediator-combine-array"
yarn link "@comunica/actor-rdf-resolve-hypermedia-links-queue-wrapper-filter-links"

