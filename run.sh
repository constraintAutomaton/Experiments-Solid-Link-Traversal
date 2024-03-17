#!/bin/bash
pushd experiments

    pushd queries-short
        ./run.sh || true
    popd
    ../backup_procedure/backup.sh || true

    pushd queries-discover
        ./run.sh || true
    popd
    ../backup_procedure/backup.sh || true

    pushd queries-complex
        ./run.sh || true
    popd
    ../backup_procedure/backup.sh || true

    pushd fragmentation
        ./run.sh || true
    popd
    ../backup_procedure/backup.sh || true
    
popd

./backup_procedure/backup.sh || true
