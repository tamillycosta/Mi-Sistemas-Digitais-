#ifndef MULTIPLICACAO_H
#define MULTIPLICACAO_H
#include <stdint.h>
//essa biblioteca é temporaria, e será usada para facilitar testes sem a FPGA

//multiplica duas matrizes5x5 de 8 bits
int mult_tmp(int8_t arr1[5][5], int8_t arr2[5][5]);
//multiplica duas matrizes5x5 de 8 bits e retorna uma de 16
int mul_completo(int8_t arr1[5][5], int8_t arr2[5][5], int16_t arr3[5][5]);
//printa uma matrix 5x5
int print_matrix5x5(int8_t arr1[5][5]);
//printa uma matriz 5x5 de 16 bits cada numero
int print_matrix5x5_16b(int16_t arr1[5][5]);

#endif