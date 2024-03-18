#!/bin/bash
pushd experiments
    find ./* -maxdepth 0 -type d -exec mkdir -p {}/generated ";"
    find ./*/input -maxdepth 0 -type d -exec cp -rf ../config-client {} ";"
    find ./*/generated -maxdepth 0 -type d -exec cp -rf ../out-validate-params {} ";"
    find ./*/generated -maxdepth 0 -type d -exec cp -rf ../out-validate {} ";"
    
    find ./* -maxdepth 0 -type d -exec yarn --cwd {} jbr generate-combinations ";"

    pushd fragmentation
        find ./combinations/combination_*[0-9]/generated -maxdepth 0 -type d -exec cp -rf ../../out-validate-params {} ";"
        find ./combinations/combination_*[0-9]/generated -maxdepth 0 -type d -exec cp -rf ../../out-validate {} ";"
    popd

popd
