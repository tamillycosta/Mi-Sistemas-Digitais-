#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "./hps_0.h"
#include <unistd.h>
#include  "assemblyFunc.h"
#include <stdlib.h>



#define LW_BRIDGE_BASE 0xFF200000
#define LW_BRIDGE_SPAM 0x00005000


// Ponteiros globais para os registradores
volatile int * flags; //0x10 PIO_1_BASE
volatile int * wr;  //  0x1000 PIO_3_BASE
volatile int * inst; // 0x100  PIO_2_BASE
volatile int8_t * dataOut; // 0x0  PIO_0_BASE
int fd = -1;
void * LW_virtual; 







int init_hardware(){
     if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
        printf("ERRO AO ABRIR O DEV/MEN\n");
        return -1;
    }

    
    LW_virtual = mmap(NULL, LW_BRIDGE_SPAM, (PROT_READ|PROT_WRITE), MAP_SHARED, fd, LW_BRIDGE_BASE);
    if (LW_virtual == MAP_FAILED)  {
        printf("ERRO NO MMAP\n");
        return -1;
    }

    flags = (int*) (LW_virtual + PIO_1_BASE);
    wr = (int*) (LW_virtual +  PIO_3_BASE);
    inst = (int*) (LW_virtual + PIO_2_BASE);
    dataOut = (int8_t*) (LW_virtual + PIO_0_BASE);


    return fd;
}


// Envia um único elemento para o hardware
void send_element(int8_t value, int i, int j, int opcode) {
    // Formato da instrução:
    // [31:10] = valor (12 bits)
    // [9:7] = i (3 bits)
    // [6:4] = j (3 bits)
    // [3:0] = opcode (4 bits)
    
    int instruction =  (value << 10) | (i << 7) |  (j << 4) |  opcode;

    *wr = 0;            // Desativa write
    *inst = instruction; // Configura instrução
    *wr = 1;            // Ativa write
    
    // Espera operação completar
    while(*flags == 0) {}
    
    *wr = 0;            // Desativa write
}


void execute_operation(int opcode ){
    
    *inst = opcode;  // Opcode da operação
    while(*flags == 0) {}  // Espera conclusão
   
}

void mult_escalar(int8_t escalar){
    // Formato da instrução:
    // 7 bits não usados (0) | 8 bits escalar | 3 bits opcode (101)
    int instruction = ((escalar & 0xFF) << 3) | 0b101;
    printf("DEBUG: Escalar = %d, Instrução = 0x%08X\n", escalar, instruction);
    *inst = instruction;  
     while(*flags == 0) {}
}

// registra overflow das operações 
void register_overflow(int i, int j, int8_t value) {
    if(overflow_count < 25) {  // Previne buffer overflow
        overflow_positions_i[overflow_count] = i;
        overflow_positions_j[overflow_count] = j;
        overflow_values[overflow_count] = value;
        overflow_count++;
    }
}

int8_t  result(int i, int j){
       *inst = (i) << 6 |((j) <<3) | 0b001;
        while(*flags == 0) {}

        int8_t value = *dataOut;

        // Verifica overflow e registra
        if(*flags >= 4) {
            register_overflow(i, j, value);
        }

        return value ;
}


int exit_program(){
    munmap(LW_virtual, LW_BRIDGE_SPAM);
    close(fd);
    return 0;
}



