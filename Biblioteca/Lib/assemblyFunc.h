#ifndef assemblyFunc_h
#define assemblyFunc_h
#include <stdint.h>


// Overflow tracking
extern int overflow_positions_i[25];
extern int overflow_positions_j[25]; 
extern int8_t overflow_values[25];
extern int overflow_count;



int init_hardware(); // inicia mapeamento de memoria 
void send_element(int8_t value, int i, int j, int opcode); // envia os elementos das matrizes de 8 a 8 bits
void execute_operation(int opcode); // opcode da operação aritimetica
void mult_escalar(int8_t  escalar);
int8_t  result(int i, int j); // retorna o resultado da operação  em 8 em 8 bits 
int exit_program();




#endif 


