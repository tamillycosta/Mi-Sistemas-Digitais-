#ifndef functions_h
#define functions_h
#include <stdint.h>

// definição das operações
#define storeMatrixA 0b0010
#define storeMatrixB 0b1010
#define loadMatrixResult 0b001

#define SUM 0b011
#define SUB 0b100
#define MULM 0b110
#define MULE 0b101
#define RST 0b011;

// protótipo das funções
void start();
void clean();
void Operation(int8_t* matrixA, int8_t* matrixB, int8_t * result);
void Aritimetic(int optionOperacao, int8_t  escalar);
void ReadResult(int8_t  * matrizResult, int size);
void PrintResult(int8_t* matrizA, int8_t* matrizB, int8_t * matrizResult, int size, int operation, int8_t escalar);
int limpeza(void);
void clear_overflow_log(void);
void print_overflow_report(void);
#endif