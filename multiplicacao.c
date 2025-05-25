#include<stdint.h>
#include <stdio.h>

#include "multiplicacao.h"

int mult_tmp(int8_t arr1[5][5], int8_t arr2[5][5]){
    for(int i=0; i<5; i++){
        for(int j=0; j<5; j++){
            arr1[i][j] = (arr1[i][j]) * (arr2[i][j]);
        } 
    }
    return 0;
}

int print_matrix5x5(int8_t arr1[5][5]){
    //printf("\n[\n");
    for(int i=0; i<5; i++){
        printf("[");
        for(int j=0; j<5; j++){
            printf("%4d ", arr1[i][j]);
        }
        printf("]\n");
    }
    //printf("]\n");
    return 0;
}