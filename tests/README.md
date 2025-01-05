## Matrices installation
```sh
./scripts/install_matrices.sh
```
Matrices will be installed into `./matrices` folder

## Build test file
Run for x86
```sh
./scripts/build_testx86.sh
```
Run for RISC-V
```sh
./scripts/build_riscv.sh
```
## Run tests
Run for x86
```sh
./scripts/runtest_x86.sh
```
Run for RISC-V
```sh
./scripts/runtest_riscv.sh
```
**If you want to save results matrices for comparing them, pass `save` argument into scripts above**. The result matrices will be saved into `./results` folder (It may take hours of time and a lot of memory for really big matrices).

## Build plots of results
If you want to build plots for all your tests and get some statistical information (mean, p-value e.t.c.) you can do following:
Run for x86
```sh
./scripts/build_plotsx86.sh
```
Run for RISC-V
```sh
./scripts/build_plotsriscv.sh
```
Plots and all info will be saved into `./measurements` folder
## Build plot of average time
If you want to see all info about accelertion on each matrix, then run:
```sh
python3 average.py
```
For correct layout it requiers both results from x86 and RISC-V tests.

## Comparing results
If you want to compare result of matrix multiplication on different architectures with vector extensions, you can run:
```sh
compareall.sh
```