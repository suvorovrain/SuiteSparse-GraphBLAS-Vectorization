#!/bin/bash

source ./path.env

echo "AVX"
cd "$SUITE_SPARSE_PATH/benchmarks/" || exit
./avx
echo "NOAVX"
cd "$SUITE_SPARSE_PATH/benchmarks/" || exit
./noavx

