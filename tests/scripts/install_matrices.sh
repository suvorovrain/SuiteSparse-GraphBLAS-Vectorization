#!/bin/bash

LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"

sizes=(10 50 500 1000 3000 6000 10000 20000 50000 100000 200000 1000000 5000000)
declare -A links

links[10]='https://suitesparse-collection-website.herokuapp.com/MM/vanHeukelum/cage4.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Grund/b1_ss.tar.gz'     

links[50]='https://suitesparse-collection-website.herokuapp.com/MM/vanHeukelum/cage5.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/HB/pores_1.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/HB/bcsstk01.tar.gz' 

links[500]='https://suitesparse-collection-website.herokuapp.com/MM/HB/bcsstm05.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/FIDAP/ex2.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/HB/494_bus.tar.gz'

links[1000]='https://suitesparse-collection-website.herokuapp.com/MM/Bai/tub1000.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Bai/cdde4.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/HB/bcsstm19.tar.gz'

links[3000]='https://suitesparse-collection-website.herokuapp.com/MM/Bai/pde2961.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Sandia/adder_dcop_41.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/HB/west1505.tar.gz'

links[6000]='https://suitesparse-collection-website.herokuapp.com/MM/Norris/heart1.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Bai/mhd4800b.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/PARSEC/Na5.tar.gz'

links[10000]=' https://suitesparse-collection-website.herokuapp.com/MM/Hollinger/mark3jac020.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Nemeth/nemeth25.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Boeing/bcsstm38.tar.gz'

links[20000]='https://suitesparse-collection-website.herokuapp.com/MM/TAMU_SmartGridCenter/ACTIVSg10K.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/HB/bcsstm25.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/ND/nd6k.tar.gz'

links[50000]='https://suitesparse-collection-website.herokuapp.com/MM/GHS_indef/sparsine.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Grund/poli4.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Belcastro/mouse_gene.tar.gz'

links[100000]='https://suitesparse-collection-website.herokuapp.com/MM/Sandia/ASIC_100ks.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/MaxPlanck/shallow_water1.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/GHS_indef/blockqp1.tar.gz'

links[200000]='https://suitesparse-collection-website.herokuapp.com/MM/PowerSystem/power197k.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/GHS_indef/d_pretok.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/PARSEC/Ga19As19H42.tar.gz'

links[1000000]='https://suitesparse-collection-website.herokuapp.com/MM/GHS_psdef/apache2.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Janna/Fault_639.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/GHS_psdef/ldoor.tar.gz'

links[5000000]='https://suitesparse-collection-website.herokuapp.com/MM/Freescale/circuit5M_dc.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Rajat/rajat31.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Janna/Cube_Coup_dt6.tar.gz'

links[30000000]='https://suitesparse-collection-website.herokuapp.com/MM/Schenk/nlpkkt240.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Schenk/nlpkkt200.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Sybrandt/MOLIERE_2016.tar.gz'  
mkdir "$SUITE_SPARSE_PATH/tests/matrices"
for size in "${sizes[@]}"; do
    echo "Installing matrices with less than $size rows"
    mkdir -p "$SUITE_SPARSE_PATH/tests/matrices/$size"
    cd "$SUITE_SPARSE_PATH/tests/matrices/$size"
    for link in ${links[$size]}; do 
        filename=$(basename "$link")
        wget "$link" -O "$filename"
        tar -xzvf "$filename"
        rm "$filename"
    done
done
