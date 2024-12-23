#!/bin/bash 

LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"
mkdir -p "$SUITE_SPARSE_PATH/tests/binaries"
gcc -fopenmp -I"$GRAPH_BLAS_PATH/Include" -I"$GRAPH_BLAS_PATH/../LAGraph/include" -o "$SUITE_SPARSE_PATH/tests/binaries/testavx" "$SUITE_SPARSE_PATH/tests/test.c" -L"$GRAPH_BLAS_PATH/build-avx/" -lgraphblas -L"$GRAPH_BLAS_PATH/../LAGraph/build-avx/src/" -llagraph -Wl,-rpath "$GRAPH_BLAS_PATH/build-avx/" -Wl,-rpath "$GRAPH_BLAS_PATH/../LAGraph/build-avx/src/"
gcc -fopenmp -I"$GRAPH_BLAS_PATH/Include" -I"$GRAPH_BLAS_PATH/../LAGraph/include" -o "$SUITE_SPARSE_PATH/tests/binaries/testnoavx" "$SUITE_SPARSE_PATH/tests/test.c" -L"$GRAPH_BLAS_PATH/build-noavx/" -lgraphblas -L"$GRAPH_BLAS_PATH/../LAGraph/build-noavx/src/" -llagraph -Wl,-rpath "$GRAPH_BLAS_PATH/build-noavx/" -Wl,-rpath "$GRAPH_BLAS_PATH/../LAGraph/build-noavx/src/"


echo "X86: Compilation completed."
