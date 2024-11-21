#!/bin/bash

source ./path.env

echo "creating folder for SuiteSpatse library"
echo "path: $SUITE_SPARSE_PATH/SuiteSparse"
mkdir "$SUITE_SPARSE_PATH/SuiteSparse"
wget -P "$SUITE_SPARSE_PATH/SuiteSparse" https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.8.3.tar.gz
echo "SuiteSparse version: 7.8.3"
tar -xzf "$SUITE_SPARSE_PATH/SuiteSparse/v7.8.3.tar.gz" -C ~/Homework/SuiteSparse-GraphBLAS-Vectorization/SuiteSparse
mv "$SUITE_SPARSE_PATH/SuiteSparse/SuiteSparse-7.8.3/"* "$SUITE_SPARSE_PATH/SuiteSparse"
rm -rf "$SUITE_SPARSE_PATH/SuiteSparse/SuiteSparse-7.8.3"
rm "$SUITE_SPARSE_PATH/SuiteSparse/v7.8.3.tar.gz"

