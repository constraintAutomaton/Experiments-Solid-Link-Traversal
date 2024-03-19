#!/bin/bash

cd ./backup_procedure && ./backup.sh

pushd experiments

    pushd queries-short
        ./run.sh || true
    popd
    cd ./../backup_procedure && ./backup.sh || true
    cd ./../experiments

    pushd queries-discover
        ./run.sh || true
    popd
    cd ./../backup_procedure && ./backup.sh || true
    cd ./../experiments

    pushd queries-complex
        ./run.sh || true
    popd
    cd ./../backup_procedure && ./backup.sh || true
    cd ./../experiments

    
popd

cd ./backup_procedure && ./backup.sh || true
