#!/bin/bash 

LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"

riscv64-unknown-linux-gnu-gcc -fopenmp -I"$GRAPH_BLAS_PATH/Include" -I"$GRAPH_BLAS_PATH/../LAGraph/include" -o "$SUITE_SPARSE_PATH/tests/binaries/testrvv" "$SUITE_SPARSE_PATH/tests/test.c" -L"$GRAPH_BLAS_PATH/build-rvv/" -lgraphblas -L"$GRAPH_BLAS_PATH/../LAGraph/build-rvv/src/" -llagraph -Wl,-rpath "$GRAPH_BLAS_PATH/build-rvv/" -Wl,-rpath "$GRAPH_BLAS_PATH/../LAGraph/build-rvv/src/"
riscv64-unknown-linux-gnu-gcc -fopenmp -I"$GRAPH_BLAS_PATH/Include" -I"$GRAPH_BLAS_PATH/../LAGraph/include" -o "$SUITE_SPARSE_PATH/tests/binaries/testnorvv" "$SUITE_SPARSE_PATH/tests/test.c" -L"$GRAPH_BLAS_PATH/build-norvv/" -lgraphblas -L"$GRAPH_BLAS_PATH/../LAGraph/build-norvv/src/" -llagraph -Wl,-rpath "$GRAPH_BLAS_PATH/build-norvv/" -Wl,-rpath "$GRAPH_BLAS_PATH/../LAGraph/build-norvv/src/"

echo "RISC-V: Compilation completed."
