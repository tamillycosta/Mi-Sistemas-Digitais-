#include<stdint.h>
#include <stdio.h>

#include "multiplicacao.h"

int mult_tmp(int8_t arr1[5][5], int8_t arr2[5][5]){
    for(int i=0; i<5; i++){
        for(int j=0; j<5; j++){
            int16_t temp = (arr1[i][j]) * (arr2[i][j]);
            if(temp>127){
                arr1[i][j] = (int8_t)127;
            }else if(temp<-128){
                arr1[i][j] = (int8_t)-128;
            }else{
                arr1[i][j] = (int8_t)temp;
            }
        } 
    }
    return 0;
}

int mul_completo(int8_t arr1[5][5], int8_t arr2[5][5], int16_t arr3[5][5]){
    for(int i=0; i<5; i++){
        for(int j=0; j<5; j++){
            arr3[i][j] = (arr1[i][j]) * (arr2[i][j]);
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

int print_matrix5x5_16b(int16_t arr1[5][5]){
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