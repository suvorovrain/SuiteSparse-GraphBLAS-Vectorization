Scripts for running SuiteSparse AVX benchmarks

# Installation Guide:

Install SuiteSparse - `/scripts/setup.sh`

*(optionally)*`/scripts/optimizations_settings.sh` - machine optimization (Sudo required. Run before running benchmark)

# For x86_64

`/scripts/makelibx86.sh` - building SuiteSparse with and without AVX

`/scripts/buildtestx86.sh` - compile benchmark binary files

`/scripts/runbenchx86.sh` - run benchmarks 

# For RISCV-64

Install riscv-gnu-toolchain https://github.com/riscv-collab/riscv-gnu-toolchain

Install qemu-user https://www.qemu.org/download/#source

`/scripts/makelibriscv.sh` - building SuiteSparse with and without AVX

`/scripts/buildtestriscv.sh` - compile benchmark binary files

`/scripts/runbenchriscv.sh` - run benchmarks 