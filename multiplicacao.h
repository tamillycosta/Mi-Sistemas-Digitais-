#ifndef MULTIPLICACAO_H
#define MULTIPLICACAO_H
#include <stdint.h>
//essa biblioteca é temporaria, e será usada para facilitar testes sem a FPGA

//multiplica duas matrizes5x5 de 8 bits
int mult_tmp(int8_t arr1[5][5], int8_t arr2[5][5]);
//printa uma matrix 5x5
int print_matrix5x5(int8_t arr1[5][5]);

#endif