#!/bin/bash

LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"
echo "Path to GraphBLAS: $GRAPH_BLAS_PATH"

cmake -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_BUILD_TYPE=Release -DGBNCPUFEAT=1 -DGBAVX2=1 -DGBX86=1 -G Ninja -S "$GRAPH_BLAS_PATH" -B "$GRAPH_BLAS_PATH/build-avx"
echo "Build library with AVX."
cmake --build "$GRAPH_BLAS_PATH/build-avx" --parallel "$(nproc)"
cmake -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_BUILD_TYPE=Release -DGBNCPUFEAT=1 -DGBAVX2=0 -DGBX86=1 -G Ninja -S "$GRAPH_BLAS_PATH" -B "$GRAPH_BLAS_PATH/build-noavx"
echo "Build library without AVX."
cmake --build "$GRAPH_BLAS_PATH/build-noavx" --parallel "$(nproc)"

