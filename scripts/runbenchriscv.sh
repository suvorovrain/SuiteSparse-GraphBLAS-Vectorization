#!/bin/bash

LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"

echo "RVV"
cd "$SUITE_SPARSE_PATH/benchmarks/" || exit
qemu-riscv64 -L /opt/riscv/sysroot -E LD_LIBRARY_PATH="$GRAPH_BLAS_PATH/build-rvv/":/opt/riscv/sysroot/ "$SUITE_SPARSE_PATH/benchmarks/rvv"

echo "NORVV"
cd "$SUITE_SPARSE_PATH/benchmarks/" || exit
qemu-riscv64 -L /opt/riscv/sysroot -E LD_LIBRARY_PATH="$GRAPH_BLAS_PATH/build-rvv/":/opt/riscv/sysroot/ "$SUITE_SPARSE_PATH/benchmarks/norvv"
