#!/bin/bash

LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"
echo "Path to GraphBLAS: $GRAPH_BLAS_PATH"

cmake -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_BUILD_TYPE=Debug -DGBNCPUFEAT=1 -DGBAVX2=1 -DGBX86=1 -G Ninja -S "$GRAPH_BLAS_PATH" -B "$GRAPH_BLAS_PATH/build-debug-avx"
echo "Build library with AVX."
cmake --build "$GRAPH_BLAS_PATH/build-debug-avx" --parallel "$(nproc)"
cmake -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_BUILD_TYPE=Debug -DGBNCPUFEAT=1 -DGBAVX2=0 -DGBX86=1 -G Ninja -S "$GRAPH_BLAS_PATH" -B "$GRAPH_BLAS_PATH/build-debug-noavx"
echo "Build library without AVX."
cmake --build "$GRAPH_BLAS_PATH/build-debug-noavx" --parallel "$(nproc)"

~                                                                        
