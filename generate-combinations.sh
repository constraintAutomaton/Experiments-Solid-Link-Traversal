#!/bin/bash
pushd experiments

    pushd queries-short
        cp -rf ../../config-client input/
        cp -rf ../../out-validate-params generated/
        cp -rf ../../out-validate generated/
        yarn jbr generate-combinations
    popd

    pushd queries-discover
        cp -rf ../../config-client input/
        cp -rf ../../out-validate-params generated/
        cp -rf ../../out-validate generated/
        yarn jbr generate-combinations
    popd

    pushd queries-complex
        cp -rf ../../config-client input/
        cp -rf ../../out-validate-params generated/
        cp -rf ../../out-validate generated/
        yarn jbr generate-combinations
    popd

    pushd fragmentation
        cp -rf ../../config-client input/
        cp -rf ../../out-validate-params generated/
        cp -rf ../../out-validate generated/
        yarn jbr generate-combinations
        find ./combinations/combination_*[0-9]/generated -maxdepth 0 -type d -exec cp -rf ../../out-validate-params {} ";"
        find ./combinations/combination_*[0-9]/generated -maxdepth 0 -type d -exec cp -rf ../../out-validate {} ";"
    popd

popd
