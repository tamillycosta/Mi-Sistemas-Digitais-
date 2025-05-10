#include <stdio.h>

extern int fpga_comunication(int num);

int main(){

    int result;
    result = fpga_comunication(5);
    printf("o valor lido é: %d\n", result);  // Imprime o retorno (r0)
    return 0;


}