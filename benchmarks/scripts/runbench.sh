#!/bin/bash

SUITE_SPARSE_PATH=$(find ~ -type d -name "SuiteSparse-GraphBLAS-Vectorization")

echo "AVX"
cd "$SUITE_SPARSE_PATH/benchmarks/"
./avx
echo "NOAVX"
cd "$SUITE_SPARSE_PATH/benchmarks/"
./noavx

