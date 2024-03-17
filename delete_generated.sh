#!/bin/bash

pushd experiments
     find ./*/generated -type d -exec rm -r {} ";"
popd