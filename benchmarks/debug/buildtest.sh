#!/bin/bash  -ex

LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"

gcc -I"$GRAPH_BLAS_PATH/Include" -o "$SUITE_SPARSE_PATH/benchmarks/davx" "$SUITE_SPARSE_PATH/benchmarks/test.c" -L"$GRAPH_BLAS_PATH/build-debug-avx/" -lgraphblas -Wl,-rpath "$GRAPH_BLAS_PATH/build-debug-avx/"
gcc -I"$GRAPH_BLAS_PATH/Include" -o "$SUITE_SPARSE_PATH/benchmarks/dnoavx" "$SUITE_SPARSE_PATH/benchmarks/test.c" -L"$GRAPH_BLAS_PATH/build-debug-noavx/" -lgraphblas -Wl,-rpath "$GRAPH_BLAS_PATH/build-debug-noavx/"

echo "Compilation completed."
