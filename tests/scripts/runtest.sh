LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"

echo "RVV"
cd "$SUITE_SPARSE_PATH/tests/" || exit
qemu-riscv64 -L /opt/riscv/sysroot -E LD_LIBRARY_PATH="$GRAPH_BLAS_PATH/build-rvv/":"$GRAPH_BLAS_PATH/../LAGraph/build-rvv/":/opt/riscv/sysroot/ "$SUITE_SPARSE_PATH/tests/binaries/testrvv" rvv

echo "NORVV"
cd "$SUITE_SPARSE_PATH/tests/" || exit
qemu-riscv64 -L /opt/riscv/sysroot -E LD_LIBRARY_PATH="$GRAPH_BLAS_PATH/build-norvv/":"$GRAPH_BLAS_PATH/../LAGraph/build-norvv/":/opt/riscv/sysroot/ "$SUITE_SPARSE_PATH/tests/binaries/testnorvv" norvv

echo "AVX"
cd "$SUITE_SPARSE_PATH/tests/binaries/" || exit
./testavx avx
echo "NOAVX"
cd "$SUITE_SPARSE_PATH/tests/binaries/" || exit
./testnoavx noavx
