#include <GraphBLAS.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <LAGraph.h>
#include <sys/stat.h>
#include <errno.h>
#include <string.h>
#include <string.h>
#include <omp.h>
void create_directory(const char *path)
{
    struct stat st = {0};
    if (stat(path, &st) == -1)
    {
#ifdef _WIN32
        _mkdir(path);
#else
        mkdir(path, 0777);
#endif
    }
}

int get_nonzero_count(const char *filename)
{
    FILE *file = fopen(filename, "r");
    if (file == NULL)
    {
        fprintf(stderr, "Error opening file");
        return -1;
    }

    char line[256];
    int rows, cols, nonzeros;

    while (fgets(line, sizeof(line), file) != NULL)
    {
        if (line[0] != '%')
        {
            break;
        }
    }
    if (sscanf(line, "%d %d %d", &rows, &cols, &nonzeros) != 3)
    {
        fprintf(stderr, "Error reading matrix dimensions\n");
        fclose(file);
        return -1;
    }

    fclose(file);
    return nonzeros;
}

int save_result_matrix(char *extension, int number, GrB_Matrix C)
{
    char filename[256];
    if (extension == NULL)
    {
        return 1;
    }
    if (strcmp(extension, "rvv") == 0)
    {
        snprintf(filename, sizeof(filename), "results/rvvresults/res_%d.txt", number);
    }
    else if (strcmp(extension, "norvv") == 0)
    {
        snprintf(filename, sizeof(filename), "results/norvvresults/res_%d.txt", number);
    }
    else if (strcmp(extension, "avx") == 0)
    {
        snprintf(filename, sizeof(filename), "results/avxresults/res_%d.txt", number);
    }
    else if (strcmp(extension, "noavx") == 0)
    {
        snprintf(filename, sizeof(filename), "results/noavxresults/res_%d.txt", number);
    }
    else
    {
        fprintf(stderr, "Error occured while reading file %s\n", extension);
        return 1;
    }

    FILE *f = fopen(filename, "w");
    if (f == NULL)
    {
        fprintf(stderr, "Error occured while reading file %s\n", filename);
        return 1;
    }

    GxB_Matrix_fprint(C, "C", GxB_COMPLETE, f);
    fclose(f);
    return 0;
}

int main(int argc, char **argv)
{

    char msg[LAGRAPH_MSG_LEN];
    msg[0] = '\0';
    GrB_Info info;
    GrB_Matrix A, B, C;

    GrB_Index nrows, ncols;
    int test_count = 110;

    info = GrB_init(GrB_NONBLOCKING);
    if (info != GrB_SUCCESS)
    {
        printf("Initialization failed!\n");
        GrB_finalize();
        return 1;
    }
    GrB_Matrix_new(&A, GrB_FP64, 0, 0);

    // INITIALIZE MATRICES
    srand(52);
    clock_t start = clock();
    char path[200];
    snprintf(path, sizeof(path), "matrices/%s/%s.mtx", argv[2], argv[2]);
    FILE *f = fopen(path, "r");
    if (f == NULL)
    {
        fprintf(stderr, "Failed to open matrix: %s\n", argv[2]);
        GrB_Matrix_free(&A);
        GrB_finalize();
        return 1;
    }
    int nonzero_count = get_nonzero_count(path);
    // int cores = omp_get_num_procs();
    // printf("cores: %d\n",cores);
    // int threads = omp_get_max_threads();
    // printf("threads: %d\n",threads);
    //  FILE *a = fopen("aoa.txt", "w");
    int result = LAGraph_MMRead(&A, f, msg);
    //  GxB_Matrix_fprint(A, "A", GxB_COMPLETE, a);
    //  fclose(a);
    GrB_Matrix_nrows(&nrows, A);
    GrB_Matrix_ncols(&ncols, A);

    GrB_Matrix_new(&B, GrB_FP64, nrows, ncols);
    GrB_Matrix_new(&C, GrB_FP64, nrows, ncols);
    // full matrix
    for (GrB_Index i = 0; i < nrows; i++)
    {
        for (GrB_Index j = 0; j < ncols; j++)
        {
            double value = (double)rand() / RAND_MAX;
            info = GrB_Matrix_setElement_FP64(B, value, i, j);
        }
    }
    GrB_set(B, GxB_FULL, GxB_SPARSITY_CONTROL);

    // result matrix
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
    printf("==============INITIALIZING TIME: %f==============\n", seconds);
    printf("==============NONZEROES:%d==============\n", nonzero_count);

    // Set Matrices type

    // GrB_set(A, GxB_SPARSE, GxB_SPARSITY_CONTROL);
    GrB_set(B, GxB_FULL, GxB_SPARSITY_CONTROL);
    GrB_set(C, GxB_FULL, GxB_SPARSITY_CONTROL);
    int32_t sparsityA;
    GrB_get(A, &sparsityA, GxB_SPARSITY_STATUS);
    printf("A matrix type: %d\n", sparsityA);
    int32_t sparsityB;
    GrB_get(B, &sparsityB, GxB_SPARSITY_STATUS);
    printf("B matrix type: %d\n", sparsityB);
    int32_t sparsityC;
    GrB_get(C, &sparsityC, GxB_SPARSITY_STATUS);
    printf("C matrix type: %d\n", sparsityC);

    // folder for measure results
    char resultpath[261];
    char dirpath[256];
    snprintf(dirpath, sizeof(dirpath), "measurements/%s%s", argv[1], argv[2]);
    create_directory("measurements");
    create_directory(dirpath);
    snprintf(resultpath, sizeof(resultpath), "%s/%s.txt", dirpath, argv[2]);

    FILE *res = fopen(resultpath, "w");
    if (res == NULL)
    {
        fprintf(stderr, "Failed to open file: %s\n", resultpath);
        GrB_finalize();
        return 1;
    }

    // add name of matrix in result
    fprintf(res, "%s;\n", argv[2]);

    // add num of rows in result
    char rows[6];
    sprintf(rows, "%ld", nrows);
    fprintf(res, "%s;\n", rows);

    // add num of non zero elements in result
    char nonzero[12];
    sprintf(nonzero, "%d", nonzero_count);
    fprintf(res, "%s;\n", nonzero);

    // run tests
    double average_time = 0.0;
    printf("=================NUBMER OF TESTS: %d=================\n", test_count);
    for (int i = 0; i < test_count; i++)
    {
        // double element;
        // GrB_Matrix_extractElement_FP64(&element,C,0,0);
        // printf("first C element %f\n",element);
        double tmxm = LAGraph_WallClockTime();
        info = GrB_mxm(C, NULL, GrB_PLUS_FP64, GxB_PLUS_TIMES_FP64, A, B, NULL);
        if (info != GrB_SUCCESS)
        {
            printf("Multiplication failed!\n");
            return 1;
        }
        tmxm = LAGraph_WallClockTime() - tmxm;
        printf("test %d: time: %f seconds\n", i + 1, tmxm);
        // printf("%g;\n", tmxm);

        // SAVE RESULT MARTIX
        //  save_result = save_result_matrix(argv[1],i,C);
        //  if (save_result != 0){
        //      printf("error occured while saving result matrix");
        //      return 1;
        //  }

        for (GrB_Index i = 0; i < nrows; i++)
        {
            for (GrB_Index j = 0; j < ncols; j++)
            {
                double value = (double)rand() / RAND_MAX;
                info = GrB_Matrix_setElement_FP64(C, 0, i, j);
            }
        }

        if (i > 9)
        {
            average_time += tmxm;
            fprintf(res, "%g;\n", tmxm);
        }
    }
    printf("Average time: %g;\n\n\n", average_time / (test_count - 1));
    fprintf(res, "%f\n", average_time / (test_count - 1));
    fclose(f);
    GrB_Matrix_free(&A);
    GrB_Matrix_free(&B);
    GrB_Matrix_free(&C);

    GrB_finalize();

    return 0;
}
