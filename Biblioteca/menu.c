#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <unistd.h> 
#include <string.h> 
//header de ultilitarios do Assembly 
#include "assemblyFunc.h"
//header de ultilitarios do  C
#include "functions.h"

// Arrays globais para armazenar informações de overflow
int overflow_positions_i[25] = {0};     // Máximo 5x5 = 25 posições
int overflow_positions_j[25] = {0};
int8_t overflow_values[25] = {0};
int overflow_count = 0;


void start() {
    int option;
    int8_t matrizA[5][5];
    int8_t matrizB[5][5];
    int8_t  result[5][5];

    while (1) {
        usleep(250000);
        printf("---------------------------------------------------------");
        usleep(1000000);
        printf("\n Seja bem vindo(a) à biblioteca de Operações Matriciais.\n");
        printf("---------------------------------------------------------\n");
        printf("\n");
        usleep(250000);
        printf("(1) - Realizar operação");
        printf("\n(2) - Sair");
        printf("\n");
        printf("\nO que deseja?: ");
        scanf("%d", &option);  // Corrigido: adicionado &
        limpeza();

        switch (option) {      // Removidas as aspas (comparando números, não caracteres)   0 


            case 1: 
                clean();
                init_hardware();
                Operation((int8_t*)matrizA, (int8_t*)matrizB, (int8_t *)result);
                break;            
            case 2: 
                exit(0);
                break;
            default: 
                printf("\nOpção inválida.\n");
                clean();
        }
    }
}


int8_t read_int8_safe(const char* prompt) {
    char input[100];
    
    
    while(1) {
        printf("%s", prompt);
        
        // Lê a linha inteira como string
        if (fgets(input, sizeof(input), stdin) != NULL) {
            // Remove o \n do final se existir
            size_t len = strlen(input);
            if (len > 0 && input[len-1] == '\n') {
                input[len-1] = '\0';
            }
            
            // Se entrada está vazia, retorna 0
            if (strlen(input) == 0) {
                printf("Entrada vazia - usando valor 0\n");
                return 0;
            }
            
            // Tenta converter para inteiro
            char* endptr;
            long temp = strtol(input, &endptr, 10);
            
            // Verifica se a conversão foi bem-sucedida
            if (*endptr == '\0') {
                // Verifica se está no range do int8_t
                if (temp >= -128 && temp <= 127) {
                    return (int8_t)temp;
                } else {
                    printf("Erro: Valor deve estar entre -128 e 127. Tente novamente.\n");
                }
            } else {
                printf("Erro: Entrada inválida. Digite um número inteiro ou pressione Enter para 0.\n");
            }
        }
    }
}

// Função para ler tamanho da matriz
int read_matrix_size(void) {
    int size;
    
    while(1) {
        printf("\nQual o tamanho da matriz (1-5)?: ");
        
        if (scanf("%d", &size) == 1) {
            limpeza(); // Limpa buffer
            
            if (size >= 1 && size <= 5) {
                return size;
            } else {
                printf("Erro: Tamanho deve estar entre 1 e 5.\n");
            }
        } else {
            printf(" Erro: Digite um número válido.\n");
            limpeza(); // Limpa buffer em caso de erro
        }
    }
}


void Operation(int8_t* matrixA, int8_t* matrixB, int8_t * matrizResult) {
    int size;
    int i, j;
    int optionOperacao;
    int8_t escalar;

    // Inicializa hardware
    int fd = init_hardware();
    if (fd < 0) return;

    // Menu de operações
    printf("\n\nOperações:\n");
    printf("(1) Soma\n(2) Subtração\n");
    printf("(3) Multiplicação de matrizes\n");
    printf("(4) Multiplicação por inteiro\n");
    printf("\nDigite uma opção: ");
    scanf("%d", &optionOperacao);
    limpeza();

    // Lê tamanho da matriz com validação
    size = read_matrix_size();

    // Recebe elementos da matriz A com validação
    printf("\nDigite os elementos da matriz A (valores entre -128 e 127):\n");
    printf("Pressione Enter sem digitar nada para usar 0\n\n");
    
    for(i = 0; i < size; i++) {
        for(j = 0; j < size; j++) {
            char prompt[50];
            snprintf(prompt, sizeof(prompt), "matrizA[%d][%d]: ", i, j);
            matrixA[i*size + j] = read_int8_safe(prompt);
        }
    }

    // Se não for multiplicação por escalar, recebe matriz B
    if(optionOperacao != 4) {
        printf("\nDigite os elementos da matriz B (valores entre -128 e 127):\n");
        printf("Pressione Enter sem digitar nada para usar 0\n\n");
        
        for(i = 0; i < size; i++) {
            for(j = 0; j < size; j++) {
                char prompt[50];
                snprintf(prompt, sizeof(prompt), "matrizB[%d][%d]: ", i, j);
                matrixB[i*size + j] = read_int8_safe(prompt);
            }
        }
    } else {
        escalar = read_int8_safe("\nDigite o número escalar (-128 a 127): ");
    }

    // Carrega matriz A no hardware
    for(i = 0; i < size; i++) {
        for(j = 0; j < size; j++) {
            send_element(matrixA[i*size + j], i, j, 0b0010); // Opcode load para matriz A
        }
    }

    // Se não for operação com escalar, carrega matriz B
    if(optionOperacao != 4) {
        for(i = 0; i < size; i++) {
            for(j = 0; j < size; j++) {
                send_element(matrixB[i*size + j], i, j, 0b1010); // Opcode load para matriz B
            }
        }
    } 

    Aritimetic(optionOperacao, escalar);
    ReadResult(matrizResult, size);
    PrintResult(matrixA, matrixB, matrizResult, size, optionOperacao, escalar);
}

// Envia opcode da operação aritimetica 
void Aritimetic(int optionOperacao, int8_t escalar){
   
    if(optionOperacao == 4){
        // Para multiplicação por escalar, chama diretamente a função
      
        mult_escalar(escalar); 
    } else {
       
        int opcode;
        switch(optionOperacao) {
            case 1: opcode = 0b011; break; // Soma
            case 2: opcode = 0b100; break; // Subtração
            case 3: opcode = 0b110; break; // Multiplicação
            default: 
                printf("Opção inválida!\n");
                return;
        }
        execute_operation(opcode); 
    }
}


// le a matriz resultado 
void ReadResult(int8_t  * matrizResult, int size){
    int i, j;

    // Limpa o log de overflow antes de começar
    clear_overflow_log();

    for(i = 0; i < size; i++) {
        for(j = 0; j < size; j++) {
            matrizResult[i*size + j]  = result(i,j); 
        }
    }
}

void PrintResult(int8_t* matrizA, int8_t* matrizB, int8_t * matrizResult, int size, int operation, int8_t escalar) {
    int i, j;
    
    // Cabeçalho explicativo
    printf("\n\n=== RESULTADO DA OPERAÇÃO ===\n");
    
    // Imprime matriz A
    printf("\nMatriz A (%dx%d):\n", size, size);
    for(i = 0; i < size; i++) {
        for(j = 0; j < size; j++) {
            printf("%4hhd ", matrizA[i*size + j]);
        }
        printf("\n");
    }
    
    
    printf("\nOperação: ");
    switch(operation) {
        case 1: printf("SOMA"); break;
        case 2: printf("SUBTRAÇÃO"); break;
        case 3: printf("MULTIPLICAÇÃO DE MATRIZES"); break;
        case 4: printf("MULTIPLICAÇÃO POR ESCALAR"); break;
        default: printf("INVÁLIDO");
    }
    printf("\n");
    
    // Imprime matriz B (exceto para multiplicação por escalar)
    if(operation != 4) {
        printf("\nMatriz B (%dx%d):\n", size, size);
        for(i = 0; i < size; i++) {
            for(j = 0; j < size; j++) {
                printf("%4hhd ", matrizB[i*size + j]);
            }
            
            printf("\n");
        }
    }else{
        printf("Escalar: %4hhd", escalar);
    }
   
    printf("\n%s\n", "--------------------------------");
    
    // Imprime matriz resultado
    printf("\nMatriz Resultado (%dx%d):\n", size, size);
    for(i = 0; i < size; i++) {
        for(j = 0; j < size; j++) {
            printf("%4hhd ", matrizResult[i*size + j]);
        }
        printf("\n");
    }
    
    // Rodapé
    printf("\n%s\n\n", "========================================");

     
    print_overflow_report();
}


void clean(){
    system("clear");
}

int limpeza(void) {
    int c;
    int houve_lixo = 0;

    while ((c = getchar()) != '\n' && c != EOF) {
        houve_lixo = 1;
    }

    return houve_lixo;
}


// Função para limpar o registro de overflows
void clear_overflow_log(void) {
    int i;
    overflow_count = 0;
   
    for(i = 0; i < 25; i++) {
        overflow_positions_i[i] = 0;
        overflow_positions_j[i] = 0;
        overflow_values[i] = 0;
    }
}


// Função para mostrar relatório de overflow
void print_overflow_report(void) {
 
    if (overflow_count > 0) {
        printf("\nRELATÓRIO DE OVERFLOW\n");
        printf("=========================================================================\n");
        printf("Foi detectado overflow na operação \n\n");
      
                   
        printf("\n Overflows ocorrem quando o resultado excede o range -128 a 127.\n");
        printf(" Considere usar valores menores ou verificar se o resultado está correto.\n");
       
        printf("===============================================================================\n\n");
    } else {
        printf("\nNenhum overflow detectado - Todos os resultados estão dentro do range válido!\n\n");
    }
}