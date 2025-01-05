#!/bin/bash

#TODO: lagraph for riscv
LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"
echo "Path to GraphBLAS: $GRAPH_BLAS_PATH"

cmake -DCMAKE_C_COMPILER=/opt/riscv/bin/riscv64-unknown-linux-gnu-gcc -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_BUILD_TYPE=Release -DGBNCPUFEAT=1 -DGBAVX2=0 -DGBX86=0 -DGBRISCV64=1 -DGBRVV=1 -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE -DCMAKE_INSTALL_RPATH="/opt/riscv/sysroot/lib:/opt/riscv/sysroot/usr/lib" -G Ninja -S "$GRAPH_BLAS_PATH" -B "$GRAPH_BLAS_PATH/build-rvv"
cmake -DCMAKE_C_COMPILER=/opt/riscv/bin/riscv64-unknown-linux-gnu-gcc -DCMAKE_CXX_COMPILER=/opt/riscv/bin/riscv64-unknown-linux-gnu-g++ -DGraphBLAS_DIR="$GRAPH_BLAS_PATH/build-rvv" -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_BUILD_TYPE=Release -G Ninja -S "$GRAPH_BLAS_PATH/../LAGraph" -B "$GRAPH_BLAS_PATH/../LAGraph/build-rvv"

echo "Build library with RVV."
cmake --build "$GRAPH_BLAS_PATH/build-rvv" --parallel "$(nproc)"
cmake --build "$GRAPH_BLAS_PATH/../LAGraph/build-rvv" --parallel "$(nproc)"

cmake -DCMAKE_C_COMPILER=/opt/riscv/bin/riscv64-unknown-linux-gnu-gcc -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_BUILD_TYPE=Release -DGBNCPUFEAT=1 -DGBAVX2=0 -DGBX86=0 -DGBRISCV64=1 -DGBRVV=0 -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE -DCMAKE_INSTALL_RPATH="/opt/riscv/sysroot/lib:/opt/riscv/sysroot/usr/lib" -G Ninja -S "$GRAPH_BLAS_PATH" -B "$GRAPH_BLAS_PATH/build-norvv"
cmake -DCMAKE_C_COMPILER=/opt/riscv/bin/riscv64-unknown-linux-gnu-gcc -DCMAKE_CXX_COMPILER=/opt/riscv/bin/riscv64-unknown-linux-gnu-g++ -DGraphBLAS_DIR="$GRAPH_BLAS_PATH/build-norvv" -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_BUILD_TYPE=Release -G Ninja -S "$GRAPH_BLAS_PATH/../LAGraph" -B "$GRAPH_BLAS_PATH/../LAGraph/build-norvv"

echo "Build library with NORVV."
cmake --build "$GRAPH_BLAS_PATH/build-norvv" --parallel "$(nproc)"
cmake --build "$GRAPH_BLAS_PATH/../LAGraph/build-norvv" --parallel "$(nproc)"


