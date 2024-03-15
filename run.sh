#!/bin/bash
pushd experiments

    pushd queries-short
        ./run.sh
    popd
    ../backup_procedure/backup.sh

    pushd queries-discover
        ./run.sh
    popd
    ../backup_procedure/backup.sh

    pushd queries-complex
        ./run.sh
    popd
    ../backup_procedure/backup.sh

    pushd fragmentation
        ./run.sh
    popd
    ../backup_procedure/backup.sh
    
popd

./backup_procedure/backup.sh
