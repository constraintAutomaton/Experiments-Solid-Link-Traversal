#!/bin/bash

cd ./backup_procedure && ./backup.sh

pushd experiments/fragmentation
        ./run.sh || true
    popd
cd ./backup_procedure && ./backup.sh