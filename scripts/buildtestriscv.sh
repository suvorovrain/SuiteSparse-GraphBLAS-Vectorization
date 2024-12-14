#!/bin/bash  -ex

LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"

riscv64-unknown-linux-gnu-gcc -I"$GRAPH_BLAS_PATH/Include" -o "$SUITE_SPARSE_PATH/benchmarks/rvv" "$SUITE_SPARSE_PATH/benchmarks/test.c" -L"$GRAPH_BLAS_PATH/build-rvv/" -lgraphblas -Wl,-rpath "$GRAPH_BLAS_PATH/build-rvv/"
riscv64-unknown-linux-gnu-gcc -I"$GRAPH_BLAS_PATH/Include" -o "$SUITE_SPARSE_PATH/benchmarks/norvv" "$SUITE_SPARSE_PATH/benchmarks/test.c" -L"$GRAPH_BLAS_PATH/build-norvv/" -lgraphblas -Wl,-rpath "$GRAPH_BLAS_PATH/build-norvv/"

echo "Compilation completed."
