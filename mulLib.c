#include "assemblyFunc.h"
#include "multiplicacao.h"
#include <stdint.h>
#include <stdio.h>


int print_matrix5x5(int8_t arr1[5][5]){
    //printf("\n[\n");
    int i, j;
    for(i=0; i<5; i++){
        printf("[");
        for(j=0; j<5; j++){
            printf("%4d ", arr1[i][j]);
        }
        printf("]\n");
    }
    //printf("]\n");
    return 0;
}




void send_matriz(int8_t arr[5][5], int opcode) {
    int i, j;
    for(i = 0; i < 5; i++) {
        for(j = 0; j < 5; j++) {
            
            send_element(arr[i][j], i, j, opcode);
        }
    }
}


// le a matriz resultado 
void ReadResult(int8_t matrizResult[5][5]) {
    int i, j;
    for( i = 0; i < 5; i++) {
        for( j = 0; j < 5; j++) {
            matrizResult[i][j] = result(i, j);
        }
    }
}



void mult_tmp(int8_t arr1[5][5], int8_t arr2[5][5], int8_t retorno[5][5]){
   
    // Carrega as matrizes no hardware
    send_matriz(arr1, 0b0010); 
    send_matriz(arr2, 0b1010); 
    
    // opcode da multiplicação 
    execute_operation(0b011); 

    ReadResult(retorno);

    execute_operation(0b111);

    //printf("Matriz 1:\n");
    //print_matrix5x5(arr1);
    //printf("Matriz 2:\n");
    //print_matrix5x5(arr2);
    //printf("Resultado:\n");
    //print_matrix5x5(retorno);

}


