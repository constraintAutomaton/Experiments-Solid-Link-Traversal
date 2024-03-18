#!/bin/bash

pushd experiments
     find ./*/generated -maxdepth 0 -type d -exec rm -rv {} \;
popd