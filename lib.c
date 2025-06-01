#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "./hps_0.h"
#include <unistd.h>

#define LW_BRIDGE_BASE 0xFF200000
#define LW_BRIDGE_SPAM 0x00005000

int main(void) {
    volatile int * flags; //0x10 PIO_1_BASE
    volatile int * wr;  //  0x1000 PIO_3_BASE
    volatile int * inst; // 0x100  PIO_2_BASE
    volatile int * dataOut; // 0x0  PIO_0_BASE
    int fd = -1;
    void * LW_virtual; 

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
    dataOut = (int*) (LW_virtual + PIO_0_BASE);

    *wr = 0;
    int a[5][5];
    int b[5][5];
    int c[5][5];

    /*teste de operações*/
    for (int i = 0; i <5; i++) {
        for(int j = 0; j < 5; j++) {
            a[i][j] = j+1;
            b[i][j] = 5 - j;
            *wr = 0;
            *inst = ((a[i][j]) << 10) | ((i) <<7) | (j << 4) | 0b0010;
            *wr = 1;
            while(*flags == 0) {}
            *wr = 0;
            *inst = ((b[i][j]) << 10) | ((i) <<7) | (j << 4) | 0b1010;
            *wr = 1;
            while(*flags == 0) {}
            *wr=0;
        }
    }

    printf("Matriz A\n");
    for (int i = 0; i<5 ;i++) {
        printf("%d %d %d %d %d\n", a[i][0], a[i][1], a[i][2], a[i][3], a[i][4]);
    }
    printf("Matriz B\n");
    for (int i = 0; i<5 ;i++) {
        printf("%d %d %d %d %d\n", b[i][0], b[i][1], b[i][2], b[i][3], b[i][4]);
    }


    *inst = 0b011;
    while(*flags == 0) {}


    printf("matriz c soma: \n");
    for(int i =0; i < 5; i++){
        for(int j =0; j<5; j++) {
            *inst =   (i) << 6 |((j) <<3) | 0b001;
            while(*flags == 0) {}

            c[i][j] = *dataOut;
            printf("%d ", *dataOut);
        }
        printf("\n");
    }

    *inst = 0b100;
    while(*flags == 0) {}


    printf("matriz c subtração: \n");
    for(int i =0; i < 5; i++){
        for(int j =0; j<5; j++) {
            *inst =   (i) << 6 |((j) <<3) | 0b001;
            while(*flags == 0) {}

            c[i][j] = *dataOut;
            printf("%d ", *dataOut);
        }
        printf("\n");
    }
    *inst = 0b111101;
    while(*flags == 0) {}


    printf("matriz c multiplicação por 7 (escalar): \n");
    for(int i =0; i < 5; i++){
        for(int j =0; j<5; j++) {
            *inst =   (i) << 6 |((j) <<3) | 0b001;
            while(*flags == 0) {}

            c[i][j] = *dataOut;
            printf("%d ", *dataOut);
        }
        printf("\n");
    }
    *inst = 0b110;
    while(*flags == 0) {}


    printf("matriz c multiplicação de matrizes: \n");
    for(int i =0; i < 5; i++){
        for(int j =0; j<5; j++) {
            *inst =   (i) << 6 |((j) <<3) | 0b001;
            while(*flags == 0) {}

            c[i][j] = *dataOut;
            printf("%d ", *dataOut);
        }
        printf("\n");
    }


 
    /*teste de acesso de endereço incorreto*/
    *inst = 0b110000001;
    printf("teste incorrect addr\n");
    while(*flags < 4) {printf("%d\n", *flags);}


    /*teste de overflow*/
    a[0][0] = 127;
    b[0][0] = 127;
    *wr = 0;
    *inst = ((a[0][0]) << 10) | ((0) <<7) | (0 << 4) | 0b0010;
    *wr = 1;
    while(*flags == 0) {}
    *wr = 0;
    *inst = ((b[0][0]) << 10) | ((0) <<7) | (0 << 4) | 0b1010;
    *wr = 1;
    while(*flags == 0) {}
    *wr=0;
    *inst = 0b011;

    printf("overflow\n");
    while(*flags < 4) {printf("%d\n", *flags);}
    *inst = 0b001;
    while(*flags < 4) {}
    printf("%d\n", *dataOut);


    *inst = 0b111;
    int x = 0;
    while(x < 3) {
        x+=1;
    }

    *inst=0b011;
    while(*flags < 4) {}

    printf("matriz c reset de matrizes: \n");
    for(int i =0; i < 5; i++){
        for(int j =0; j<5; j++) {
            *inst =   (i) << 6 |((j) <<3) | 0b001;
            while(*flags == 0) {}

            c[i][j] = *dataOut;
            printf("%d ", *dataOut);
        }
        printf("\n");
    }


    for (int i = 0; i <3; i++) {
        for(int j = 0; j < 2; j++) {
            a[i][j] = 10 + j;
            b[j][i] = 10 + j;
            *wr = 0;
            *inst = ((a[i][j]) << 10) | ((i) <<7) | (j << 4) | 0b0010;
            *wr = 1;
            while(*flags == 0) {}
            *wr = 0;
            *inst = ((b[i][j]) << 10) | ((i) <<7) | (j << 4) | 0b1010;
            *wr = 1;
            while(*flags == 0) {}
            *wr=0;
        }
    }

    *inst=0b110;
    while(*flags < 4) {}

    printf("matriz c multiplicacao de matrizes tamanho diferente: \n");
    for(int i =0; i < 5; i++){
        for(int j =0; j<5; j++) {
            *inst =   (i) << 6 |((j) <<3) | 0b001;
            while(*flags == 0) {}

            c[i][j] = *dataOut;
            printf("%d ", *dataOut);
        }
        printf("\n");
    }

    munmap(LW_virtual, LW_BRIDGE_SPAM);

    close(fd);

    return 0;
}
