#include <GraphBLAS.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
    GrB_Info info;
    GrB_Matrix A, B, C;

    GrB_Index nrows = 2000, ncols = 2000;
    int test_count = 20;

    info = GrB_init(GrB_NONBLOCKING);
    if (info != GrB_SUCCESS)
    {
        printf("Initialization failed!\n");
        return 1;
    }
    GrB_Matrix_new(&A, GrB_FP64, nrows, ncols);
    GrB_Matrix_new(&B, GrB_FP64, nrows, ncols);
    GrB_Matrix_new(&C, GrB_FP64, nrows, ncols);

    GrB_set(B, GxB_FULL, GxB_SPARSITY_CONTROL);
    // INITIALIZE MATRICES
    srand(52);
    clock_t start = clock();
    for (GrB_Index i = 0; i < nrows; i++)
    {
        for (GrB_Index j = 0; j < ncols; j++)
        {
            double value = (double)rand() / RAND_MAX;
            info = GrB_Matrix_setElement_FP64(A, value, i, j);
        }
    }

    for (GrB_Index i = 0; i < nrows; i++)
    {
        for (GrB_Index j = 0; j < ncols; j++)
        {
            double value = (double)rand() / RAND_MAX;
            info = GrB_Matrix_setElement_FP64(B, value, i, j);
        }
    }

    for (GrB_Index i = 0; i < nrows; i++)
    {
        for (GrB_Index j = 0; j < ncols; j++)
        {
            double value = (double)rand() / RAND_MAX;
            info = GrB_Matrix_setElement_FP64(C, 0, i, j);
        }
    }
    clock_t end = clock();
    float seconds = (float)(end - start) / CLOCKS_PER_SEC;
    printf("==============MATRIX SIZE: %lux%lu==============\n", nrows, ncols);
    printf("==============INITIALIZING TIME: %f==============\n\n", seconds);

    // Set Matrices type

    GrB_set(A, GxB_SPARSE, GxB_SPARSITY_CONTROL);
    GrB_set(B, GxB_FULL, GxB_SPARSITY_CONTROL);
    GrB_set(C, GxB_FULL, GxB_SPARSITY_CONTROL);
    int32_t sparsityA;
    GrB_get(A, &sparsityA, GxB_SPARSITY_STATUS);
    //printf("A matrix type: %d\n", sparsityA);
    int32_t sparsityB;
    GrB_get(B, &sparsityB, GxB_SPARSITY_STATUS);
  //  printf("B matrix type: %d\n", sparsityB);
    int32_t sparsityC;
    GrB_get(C, &sparsityC, GxB_SPARSITY_STATUS);
//    printf("C matrix type: %d\n", sparsityB);

    float average_time = 0.0;
    printf("=================NUBMER OF TESTS: %d=================\n", test_count);
    for (int i = 0; i < test_count; i++)
    {
        // double element;
        // GrB_Matrix_extractElement_FP64(&element,C,0,0);
        // printf("first C element %f\n",element);
        clock_t start = clock();
        info = GrB_mxm(C, NULL, GrB_PLUS_FP64, GxB_PLUS_TIMES_FP64, A, B, NULL);
        if (info != GrB_SUCCESS)
        {
            printf("Multiplication failed!\n");
            return 1;
        }
        clock_t end = clock();
        float seconds = (float)(end - start) / CLOCKS_PER_SEC;
        // printf("test %d: time: %f\n", i + 1, seconds);
        printf("%f;\n", seconds);
        average_time += seconds;
        for (GrB_Index i = 0; i < nrows; i++)
        {
            for (GrB_Index j = 0; j < ncols; j++)
            {
                double value = (double)rand() / RAND_MAX;
                info = GrB_Matrix_setElement_FP64(C, 0, i, j);
            }
        }
        if (i==0){
            average_time -= seconds;
        }
    }
    printf("average time: %f\n", average_time / (test_count-1));
    // printf("%f\n", average_time / test_count);

    GrB_Matrix_free(&A);
    GrB_Matrix_free(&B);
    GrB_Matrix_free(&C);

    GrB_finalize();

    return 0;
}
