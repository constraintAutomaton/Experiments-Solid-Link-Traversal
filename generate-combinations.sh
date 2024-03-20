#!/bin/bash
pushd experiments
    find ./* -maxdepth 0 -type d -exec mkdir -p {}/generated ";"
    find ./*/input -maxdepth 0 -type d -exec cp -rf ../config-client {} ";"
    find ./*/generated -maxdepth 0 -type d -exec cp -rf ../out-validate-params {} ";"
    find ./*/generated -maxdepth 0 -type d -exec cp -rf ../out-validate {} ";"
    
    pushd queries-short
        yarn run jbr generate-combinations
    popd

    pushd queries-discover
        yarn run jbr generate-combinations
    popd

    pushd queries-complex
        yarn run jbr generate-combinations
    popd


    pushd fragmentation
        find ./combinations/combination_*[0-9]/generated -maxdepth 0 -type d -exec cp -rf ../../out-validate-params {} ";"
        find ./combinations/combination_*[0-9]/generated -maxdepth 0 -type d -exec cp -rf ../../out-validate {} ";"
        yarn run jbr generate-combinations
    popd

popd
