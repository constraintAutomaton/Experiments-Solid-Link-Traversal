#!/bin/bash
rm -rf node_modules

pushd experiments

    pushd queries-short
        rm -rf node_modules
        rm -r generated/*
        rm -r combinations/*
        rm -r output/*
    popd

    pushd queries-discover
        rm -rf node_modules
        rm -r generated/*
        rm -r combinations/*
        rm -r output/*
    popd

    pushd queries-complex
        rm -rf node_modules
        rm -r generated/*
        rm -r combinations/*
        rm -r output/*
    popd

    pushd fragmentation
        rm -rf node_modules
        rm -r generated/*
        rm -r combinations/*
        rm -r output/*
    popd

popd