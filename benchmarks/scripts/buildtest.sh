#!/bin/bash  -ex

LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"

gcc -I"$GRAPH_BLAS_PATH/Include" -o "$SUITE_SPARSE_PATH/benchmarks/avx" "$SUITE_SPARSE_PATH/benchmarks/test.c" -L"$GRAPH_BLAS_PATH/build-avx/" -lgraphblas -Wl,-rpath "$GRAPH_BLAS_PATH/build-avx/"
gcc -I"$GRAPH_BLAS_PATH/Include" -o "$SUITE_SPARSE_PATH/benchmarks/noavx" "$SUITE_SPARSE_PATH/benchmarks/test.c" -L"$GRAPH_BLAS_PATH/build-noavx/" -lgraphblas -Wl,-rpath "$GRAPH_BLAS_PATH/build-noavx/"

echo "Compilation completed."
