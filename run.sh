#!/bin/bash

(cd ./backup_procedure && ./backup.sh) 2>> ./../errors

pushd experiments

    pushd queries-short
        ./run.sh 2>> ./../../errors
    popd

    (cd ./../backup_procedure && ./backup.sh) 2>> ./../../errors
    ./../clean_docker.sh
    cd ./../experiments

    pushd queries-discover
        ./run.sh 2>> ./../../errors
    popd
    (cd ./../backup_procedure && ./backup.sh) 2>> ./../../errors
    ./../clean_docker.sh
    cd ./../experiments

    pushd queries-complex
        ./run.sh 2>> ./../../errors
    popd
    (cd ./../backup_procedure && ./backup.sh) 2>> ./../../errors
    ./../clean_docker.sh
    cd ./../experiments
popd

cd ./backup_procedure && ./backup.sh 2>> ./../errors
