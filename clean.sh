#!/bin/bash
rm -rf node_modules

pushd experiments
    find ./*/node_modules -maxdepth 0 -type d -exec rm -rv {} \;
    find ./*/combinations/* -type d -exec rm -rv {} \;
    find ./*/output/* -maxdepth 0 -type d -exec rm -rv {} \;