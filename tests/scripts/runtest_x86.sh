LIBPATH=$(dirname "$(realpath "$0")")
source "$LIBPATH/path.env"

links=(https://suitesparse-collection-website.herokuapp.com/MM/Bai/olm500.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/MathWorks/tomography.tar.gz #500
https://suitesparse-collection-website.herokuapp.com/MM/VDOL/orbitRaising_3.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/HB/mcfe.tar.gz #750
https://suitesparse-collection-website.herokuapp.com/MM/ML_Graph/collins_15NN.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Bai/olm1000.tar.gz #1000
https://suitesparse-collection-website.herokuapp.com/MM/VDOL/reorientation_2.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Newman/netscience.tar.gz #1500
https://suitesparse-collection-website.herokuapp.com/MM/Oberwolfach/piston.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/HB/west2021.tar.gz #2000
https://suitesparse-collection-website.herokuapp.com/MM/LeGresley/LeGresley_2508.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Moqri/MISKnowledgeMap.tar.gz #2500
https://suitesparse-collection-website.herokuapp.com/MM/Meszaros/iprob.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/FIDAP/ex36.tar.gz #3000
https://suitesparse-collection-website.herokuapp.com/MM/HB/bcsstk15.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Bai/tols4000.tar.gz #4000 
https://suitesparse-collection-website.herokuapp.com/MM/VDOL/freeFlyingRobot_12.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Cylshell/s3rmq4m1.tar.gz #5500
https://suitesparse-collection-website.herokuapp.com/MM/Hohn/sinc12.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Hohn/fd12.tar.gz #7500
https://suitesparse-collection-website.herokuapp.com/MM/Bai/cryg10000.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Goodwin/Goodwin_030.tar.gz #10000
https://suitesparse-collection-website.herokuapp.com/MM/GHS_indef/stokes64.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/FEMLAB/sme3Da.tar.gz #12500
https://suitesparse-collection-website.herokuapp.com/MM/Hohn/fd18.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Simon/olafu.tar.gz #16000
# 
# https://suitesparse-collection-website.herokuapp.com/MM/Schenk_IBMNA/c-49.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/Simon/raefsky3.tar.gz #21000
# https://suitesparse-collection-website.herokuapp.com/MM/Boeing/bcsstm37.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/TSOPF/TSOPF_RS_b2052_c1.tar.gz #25500
# https://suitesparse-collection-website.herokuapp.com/MM/Boeing/bcsstm35.tar.gz https://suitesparse-collection-website.herokuapp.com/MM/TSOPF/TSOPF_FS_b162_c3.tar.gz #30500
)

save=$1

echo "AVX TESTS"
cd "$SUITE_SPARSE_PATH/tests/" || exit
for link in "${links[@]}"; do
    base_name=$(basename "$link")
    filename=${base_name%%.*}
    echo "Matrix: $filename"
    ./binaries/testavx avx "$filename" "$save"
done

echo "NOAVX TESTS"
cd "$SUITE_SPARSE_PATH/tests/" || exit
for link in "${links[@]}"; do
    base_name=$(basename "$link")
    filename=${base_name%%.*}
    echo "Matrix: $filename"
    ./binaries/testavx noavx "$filename" "$save"
done

