Scripts for running SuiteSparse AVX benchmarks

# Installation Guide:

Install SuiteSparse 
```sh
./scripts/setup.sh
```

Machine optimization (Sudo required. Run before running benchmark)
 ```sh
 ./scripts/optimizations_settings.sh
 ```

## For x86_64

 Build SuiteSparse with and without AVX
```sh
./scripts/makelibx86.sh
``` 

## For RISCV-64

Install riscv-gnu-toolchain https://github.com/riscv-collab/riscv-gnu-toolchain

Install qemu-user https://www.qemu.org/download/#source

Build SuiteSparse with and without RVV
```sh
/scripts/makelibriscv.sh
``` 
For testsrunnning see /test/README.md
