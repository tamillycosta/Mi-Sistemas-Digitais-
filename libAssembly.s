@ ============================================================================
@ Hardware Memory Controller Interface
@ ARM Cortex-A7 Assembly Implementation
@ 
@ Este código implementa uma interface para controle de hardware através de
@ mapeamento de memória (/dev/mem). Permite envio de instruções para um
@ processador ou FPGA especializado através de registradores mapeados.
@ ============================================================================

    .syntax unified
    .arch armv7-a
    .thumb

@ ============================================================================
@ SEÇÃO DE DADOS
@ ============================================================================

    .data
    .align 2

@ Arquivo descriptor para /dev/mem
hardware_fd:
    .word -1

@ Strings de erro
device_path:
    .asciz "/dev/mem"
    
error_open_device:
    .asciz "ERRO: Não foi possível abrir /dev/mem"
    
error_memory_map:
    .asciz "ERRO: Falha no mapeamento de memória"

@ ============================================================================
@ VARIÁVEIS GLOBAIS BSS
@ ============================================================================

    .comm hardware_flags_ptr, 4, 4      @ Ponteiro para registrador de flags
    .comm write_enable_ptr, 4, 4        @ Ponteiro para registrador de escrita
    .comm instruction_ptr, 4, 4         @ Ponteiro para registrador de instrução
    .comm data_output_ptr, 4, 4         @ Ponteiro para saída de dados
    .comm memory_base_ptr, 4, 4         @ Ponteiro base do mapeamento
    .comm overflow_count, 4, 4          @ Contador de overflows
    .comm overflow_positions_i, 100, 4  @ Array de posições i dos overflows
    .comm overflow_positions_j, 100, 4  @ Array de posições j dos overflows
    .comm overflow_values, 25, 1        @ Array de valores que causaram overflow

@ ============================================================================
@ CONSTANTES DE HARDWARE
@ ============================================================================

.equ MEMORY_SIZE,     20480          @ Tamanho do mapeamento (20KB)
.equ FLAGS_OFFSET,    16             @ Offset para registrador de flags
.equ WRITE_OFFSET,    4096           @ Offset para registrador de escrita
.equ INSTRUCTION_OFFSET, 256         @ Offset para registrador de instrução
.equ DATA_OFFSET,     0              @ Offset para dados de saída

.equ MAX_OVERFLOWS,   24             @ Máximo de overflows a registrar

@ Opcodes das instruções
.equ OP_READ,         0x01           @ Operação de leitura
.equ OP_SCALAR_MULT,  0x05           @ Multiplicação escalar

@ ============================================================================
@ FUNÇÃO: init_hardware
@ Inicializa o acesso ao hardware através de mapeamento de memória
@ 
@ Retorno: r0 = file descriptor (sucesso) ou -1 (erro)
@ ============================================================================

    .text
    .align 2
    .global init_hardware
    .thumb_func

init_hardware:
    push {r7, lr}
    sub sp, sp, #8
    add r7, sp, #8

open_device:
    @ Abre o dispositivo /dev/mem para acesso à memória física
    ldr r0, =device_path
    movw r1, #0x1002                 @ O_RDWR | O_SYNC (parte baixa)
    movt r1, #0                      @ Parte alta = 0
    bl open
    
    @ Armazena o file descriptor
    ldr r3, =hardware_fd
    str r0, [r3]
    
    @ Verifica se a abertura foi bem-sucedida
    cmp r0, #-1
    bne setup_memory_mapping
    
handle_open_error:
    ldr r0, =error_open_device
    bl puts
    mov r0, #-1
    b cleanup_and_return

setup_memory_mapping:
    @ Mapeia a região de memória do hardware
    @ mmap(addr=0, length=MEMORY_SIZE, prot=PROT_READ|PROT_WRITE, 
    @      flags=MAP_SHARED, fd=hardware_fd, offset=BASE_ADDRESS)
    
    mov r0, #0                       @ addr = NULL (kernel escolhe)
    movw r1, #20480                  @ length = MEMORY_SIZE (parte baixa)
    movt r1, #0                      @ length (parte alta)
    mov r2, #3                       @ prot = PROT_READ | PROT_WRITE
    mov r3, #1                       @ flags = MAP_SHARED
    
    @ Parâmetros adicionais na pilha
    ldr r4, =hardware_fd
    ldr r4, [r4]
    str r4, [sp, #0]                 @ fd
    
    movw r4, #0x0000                 @ BASE_ADDRESS parte baixa
    movt r4, #0xFF20                 @ BASE_ADDRESS parte alta (0xFF200000)
    str r4, [sp, #4]                 @ offset
    
    bl mmap
    
    @ Verifica se o mapeamento foi bem-sucedido
    ldr r3, =memory_base_ptr
    str r0, [r3]
    
    cmp r0, #-1
    bne setup_hardware_pointers

handle_mmap_error:
    ldr r0, =error_memory_map
    bl puts
    mov r0, #-1
    b cleanup_and_return

setup_hardware_pointers:
    @ Configura os ponteiros para os diferentes registradores
    ldr r3, =memory_base_ptr
    ldr r3, [r3]
    
    @ Ponteiro para flags (base + FLAGS_OFFSET)
    add r2, r3, #FLAGS_OFFSET
    ldr r1, =hardware_flags_ptr
    str r2, [r1]
    
    @ Ponteiro para write enable (base + WRITE_OFFSET)
    movw r4, #4096                   @ WRITE_OFFSET
    movt r4, #0
    add r2, r3, r4
    ldr r1, =write_enable_ptr
    str r2, [r1]
    
    @ Ponteiro para instrução (base + INSTRUCTION_OFFSET)
    movw r4, #256                    @ INSTRUCTION_OFFSET  
    movt r4, #0
    add r2, r3, r4
    ldr r1, =instruction_ptr
    str r2, [r1]
    
    @ Ponteiro para dados de saída (base + DATA_OFFSET)
    ldr r1, =data_output_ptr
    str r3, [r1]
    
    @ Retorna o file descriptor (sucesso)
    ldr r3, =hardware_fd
    ldr r0, [r3]

cleanup_and_return:
    mov sp, r7
    pop {r7, pc}

@ ============================================================================
@ FUNÇÃO: send_element
@ Envia um elemento para processamento no hardware
@ 
@ Parâmetros:
@   r0 = value (valor de 8 bits)
@   r1 = i (coordenada linha)
@   r2 = j (coordenada coluna) 
@   r3 = opcode (código da operação)
@ ============================================================================

    .align 2
    .global send_element
    .thumb_func

send_element:
    push {r7}
    sub sp, sp, #28
    add r7, sp, #0
    
    @ Salva os parâmetros
    strb r0, [r7, #15]               @ value (8 bits)
    str r1, [r7, #8]                 @ i
    str r2, [r7, #4]                 @ j
    str r3, [r7, #0]                 @ opcode

build_instruction:
    @ Constrói a instrução no formato esperado pelo hardware:
    @ [31:10] = value (sinal estendido)
    @ [9:7]   = i (índice linha)
    @ [6:4]   = j (índice coluna)
    @ [3:0]   = opcode
    
    ldrsb r3, [r7, #15]              @ Carrega value com extensão de sinal
    lsl r2, r3, #10                  @ value << 10
    
    ldr r3, [r7, #8]                 @ i
    lsl r3, r3, #7                   @ i << 7
    orr r2, r2, r3                   @ instruction |= (i << 7)
    
    ldr r3, [r7, #4]                 @ j
    lsl r3, r3, #4                   @ j << 4
    orr r2, r2, r3                   @ instruction |= (j << 4)
    
    ldr r3, [r7, #0]                 @ opcode
    orr r3, r3, r2                   @ instruction |= opcode
    str r3, [r7, #20]                @ Salva instrução completa

send_instruction:
    @ Desabilita escrita primeiro
    ldr r3, =write_enable_ptr
    ldr r3, [r3]
    mov r2, #0
    str r2, [r3]
    
    @ Escreve a instrução
    ldr r3, =instruction_ptr
    ldr r3, [r3]
    ldr r2, [r7, #20]
    str r2, [r3]
    
    @ Habilita escrita para disparar o processamento
    ldr r3, =write_enable_ptr
    ldr r3, [r3]
    mov r2, #1
    str r2, [r3]

wait_for_completion:
    @ Aguarda o hardware sinalizar conclusão através do flag
    ldr r3, =hardware_flags_ptr
    ldr r3, [r3]
    ldr r3, [r3]
    cmp r3, #0
    beq wait_for_completion
    
    @ Desabilita escrita após conclusão
    ldr r3, =write_enable_ptr
    ldr r3, [r3]
    mov r2, #0
    str r2, [r3]
    
    add r7, r7, #28
    mov sp, r7
    pop {r7}
    bx lr

@ ============================================================================
@ FUNÇÃO: execute_operation  
@ Executa uma operação simples no hardware
@
@ Parâmetros:
@   r0 = opcode (código da operação)
@ ============================================================================

    .align 2
    .global execute_operation
    .thumb_func

execute_operation:
    push {r7}
    sub sp, sp, #12
    add r7, sp, #0
    
    str r0, [r7, #4]                 @ Salva opcode

send_simple_instruction:
    @ Envia instrução simples (apenas opcode)
    ldr r3, =instruction_ptr
    ldr r3, [r3]
    ldr r2, [r7, #4]
    str r2, [r3]

wait_for_simple_completion:
    @ Aguarda conclusão
    ldr r3, =hardware_flags_ptr
    ldr r3, [r3]
    ldr r3, [r3]
    cmp r3, #0
    beq wait_for_simple_completion
    
    add r7, r7, #12
    mov sp, r7
    pop {r7}
    bx lr

@ ============================================================================
@ FUNÇÃO: mult_escalar
@ Executa multiplicação escalar no hardware
@
@ Parâmetros:
@   r0 = escalar (valor de 8 bits)
@ ============================================================================

    .align 2
    .global mult_escalar
    .thumb_func

mult_escalar:
    push {r7, lr}
    sub sp, sp, #16
    add r7, sp, #0
    
    strb r0, [r7, #7]                @ Salva escalar

build_scalar_instruction:
    @ Constrói instrução de multiplicação escalar:
    @ [31:3] = escalar (zero extended)
    @ [2:0]  = OP_SCALAR_MULT (0x05)
    
    ldrb r3, [r7, #7]                @ Carrega escalar (sem sinal)
    lsl r3, r3, #3                   @ escalar << 3
    orr r3, r3, #OP_SCALAR_MULT      @ instruction = (escalar << 3) | 0x05
    str r3, [r7, #12]

execute_scalar_instruction:
    @ Envia instrução para o hardware
    ldr r3, =instruction_ptr
    ldr r3, [r3]
    ldr r2, [r7, #12]
    str r2, [r3]

wait_for_scalar_completion:
    @ Aguarda conclusão da multiplicação
    ldr r3, =hardware_flags_ptr
    ldr r3, [r3]
    ldr r3, [r3]
    cmp r3, #0
    beq wait_for_scalar_completion
    
    add r7, r7, #16
    mov sp, r7
    pop {r7, pc}

@ ============================================================================
@ FUNÇÃO: register_overflow
@ Registra casos de overflow para análise posterior
@
@ Parâmetros:
@   r0 = i (coordenada linha)
@   r1 = j (coordenada coluna)
@   r2 = value (valor que causou overflow)
@ ============================================================================

    .align 2
    .global register_overflow
    .thumb_func

register_overflow:
    push {r7}
    sub sp, sp, #20
    add r7, sp, #0
    
    str r0, [r7, #12]                @ i
    str r1, [r7, #8]                 @ j
    strb r2, [r7, #7]                @ value

check_overflow_capacity:
    @ Verifica se ainda há espaço para registrar overflows
    ldr r3, =overflow_count
    ldr r3, [r3]
    cmp r3, #MAX_OVERFLOWS
    bgt overflow_buffer_full

store_overflow_data:
    @ Armazena posição i
    ldr r3, =overflow_count
    ldr r2, [r3]
    ldr r3, =overflow_positions_i
    ldr r1, [r7, #12]                @ i
    str r1, [r3, r2, lsl #2]         @ overflow_positions_i[count] = i
    
    @ Armazena posição j
    ldr r3, =overflow_count
    ldr r2, [r3]
    ldr r3, =overflow_positions_j
    ldr r1, [r7, #8]                 @ j
    str r1, [r3, r2, lsl #2]         @ overflow_positions_j[count] = j
    
    @ Armazena valor
    ldr r3, =overflow_count
    ldr r2, [r3]
    ldr r3, =overflow_values
    ldrb r1, [r7, #7]                @ value
    strb r1, [r3, r2]                @ overflow_values[count] = value
    
    @ Incrementa contador
    ldr r3, =overflow_count
    ldr r2, [r3]
    add r2, r2, #1
    str r2, [r3]

overflow_buffer_full:
    add r7, r7, #20
    mov sp, r7
    pop {r7}
    bx lr

@ ============================================================================
@ FUNÇÃO: result
@ Lê resultado do hardware e verifica overflow
@
@ Parâmetros:
@   r0 = i (coordenada linha)  
@   r1 = j (coordenada coluna)
@
@ Retorno:
@   r0 = valor lido (com sinal)
@ ============================================================================

    .align 2
    .global result
    .thumb_func

result:
    push {r7, lr}
    sub sp, sp, #16
    add r7, sp, #0
    
    str r0, [r7, #4]                 @ i
    str r1, [r7, #0]                 @ j

send_read_instruction:
    @ Constrói e envia instrução de leitura:
    @ [31:6] = i << 6
    @ [5:3]  = j << 3  
    @ [2:0]  = OP_READ (0x01)
    
    ldr r3, =instruction_ptr
    ldr r3, [r3]
    
    ldr r2, [r7, #4]                 @ i
    lsl r1, r2, #6                   @ i << 6
    
    ldr r2, [r7, #0]                 @ j
    lsl r2, r2, #3                   @ j << 3
    orr r2, r2, r1                   @ (j << 3) | (i << 6)
    
    orr r2, r2, #OP_READ             @ instruction |= OP_READ
    str r2, [r3]

wait_for_result:
    @ Aguarda hardware completar a operação
    ldr r3, =hardware_flags_ptr
    ldr r3, [r3]
    ldr r3, [r3]
    cmp r3, #0
    beq wait_for_result

check_overflow_condition:
    @ Verifica se houve overflow (flag > 2 indica overflow)
    ldr r3, =hardware_flags_ptr
    ldr r3, [r3]
    ldr r3, [r3]
    cmp r3, #2
    ble read_output_data
    
register_overflow_case:
    @ Registra o overflow
    mov r2, #0                       @ value placeholder
    ldr r0, [r7, #4]                 @ i
    ldr r1, [r7, #0]                 @ j
    bl register_overflow

read_output_data:
    @ Lê o resultado do hardware
    ldr r3, =data_output_ptr
    ldr r3, [r3]
    ldrb r3, [r3]                    @ Lê byte (sem sinal)
    sxtb r0, r3                      @ Converte para com sinal
    
    add r7, r7, #16
    mov sp, r7
    pop {r7, pc}

@ ============================================================================
@ FUNÇÃO: exit_program
@ Limpa recursos e finaliza o programa
@
@ Retorno: r0 = 0 (sempre sucesso)
@ ============================================================================

    .align 2
    .global exit_program
    .thumb_func

exit_program:
    push {r7, lr}
    add r7, sp, #0

unmap_memory:
    @ Remove o mapeamento de memória
    ldr r3, =memory_base_ptr
    ldr r0, [r3]                     @ endereço base
    movw r1, #20480                  @ MEMORY_SIZE
    movt r1, #0
    bl munmap

close_device:
    @ Fecha o file descriptor
    ldr r3, =hardware_fd
    ldr r0, [r3]
    bl close
    
    @ Retorna sucesso
    mov r0, #0
    pop {r7, pc}
	