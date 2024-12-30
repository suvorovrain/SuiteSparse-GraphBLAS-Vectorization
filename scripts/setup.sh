#!/bin/bash

LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"

echo "creating folder for SuiteSpatse library"
echo "path: $SUITE_SPARSE_PATH/SuiteSparse"
mkdir "$SUITE_SPARSE_PATH/SuiteSparse"
git clone https://github.com/suvorovrain/SuiteSparse.git -b riscv64rvv --depth 1 "$SUITE_SPARSE_PATH/SuiteSparse"
