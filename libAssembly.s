@ ============================================================================
@ Hardware Interface Library for ARM Cortex-A (ARMv7-A)
@ 
@ Este código implementa uma interface de baixo nível para comunicação com
@ hardware personalizado através de memory-mapped I/O usando /dev/mem
@
@ Arquitetura: ARMv7-A com VFPv3-D16 (Hard Float ABI)
@ Compilador: Escrito para GCC ARM com Thumb-2 instruction set
@ ============================================================================

    .syntax unified
    .arch armv7-a
    .thumb

@ ============================================================================
@ SEÇÃO DE DADOS E VARIÁVEIS GLOBAIS
@ ============================================================================

    .data
    .align 2

@ Descritor de arquivo para /dev/mem - inicializado como inválido
file_descriptor:
    .word -1

    .bss
    .align 2

@ Ponteiros para regiões mapeadas em memória
hardware_flags:     .space 4    @ Ponteiro para registro de flags/status
write_register:     .space 4    @ Ponteiro para registro de escrita
instruction_reg:    .space 4    @ Ponteiro para registro de instruções
data_output:        .space 4    @ Ponteiro para dados de saída
virtual_base:       .space 4    @ Base do mapeamento virtual

@ ============================================================================
@ CONSTANTES E STRINGS
@ ============================================================================

    .section .rodata
    .align 2

device_path:
    .asciz "/dev/mem"

error_open_device:
    .asciz "ERRO AO ABRIR O /DEV/MEM"

error_memory_map:
    .asciz "ERRO NO MMAP"

@ ============================================================================
@ FUNÇÕES PRINCIPAIS
@ ============================================================================

    .text
    .align 2

@ ----------------------------------------------------------------------------
@ init_hardware: Inicializa interface com hardware
@ 
@ Esta função configura o acesso ao hardware através de memory mapping:
@ 1. Abre /dev/mem com permissões de leitura/escrita
@ 2. Mapeia região física 0xFF200000 (base Cyclone V DE1-SoC)
@ 3. Configura ponteiros para diferentes registros do hardware
@
@ Retorno: file descriptor em r0 (negativo se erro)
@ ----------------------------------------------------------------------------
    .global init_hardware
    .thumb_func
init_hardware:
    push {r7, lr}
    sub sp, sp, #8
    add r7, sp, #8

open_device:
    @ Abrir /dev/mem com O_RDWR | O_SYNC (0x1002)
    ldr r0, =device_path
    movw r1, #0x1002        @ O_RDWR | O_SYNC para acesso sincronizado
    bl open
    
    @ Salvar file descriptor
    ldr r1, =file_descriptor
    str r0, [r1]
    
    @ Verificar se abertura foi bem-sucedida
    cmp r0, #-1
    bne setup_memory_mapping

handle_open_error:
    ldr r0, =error_open_device
    bl puts
    mov r0, #-1
    b cleanup_and_return

setup_memory_mapping:
    
    @ mmap(NULL, 20480, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0xFF200000)
    
    ldr r3, =file_descriptor
    ldr r3, [r3]            @ Carregar file descriptor
    str r3, [sp, #0]        @ fd no stack
    
    @ Offset físico: 0xFF200000 (base dos periféricos Cyclone V)
    mov r3, #0x200000
    add r3, r3, #0xFF000000
    str r3, [sp, #4]        @ offset no stack
    
    mov r0, #0              @ addr = NULL (deixar kernel escolher)
    mov r1, #20480          @ length = 20KB (suficiente para periféricos)
    mov r2, #3              @ prot = PROT_READ | PROT_WRITE
    mov r3, #1              @ flags = MAP_SHARED
    bl mmap
    
    @ Verificar resultado do mmap
    ldr r1, =virtual_base
    str r0, [r1]
    cmp r0, #-1
    bne configure_hardware_pointers

handle_mmap_error:
    ldr r0, =error_memory_map
    bl puts
    mov r0, #-1
    b cleanup_and_return

configure_hardware_pointers:
    @ Configurar ponteiros para diferentes registros baseados no mapeamento
    ldr r1, =virtual_base
    ldr r1, [r1]
    
    @ Flags/Status register (offset +16 bytes)
    add r2, r1, #16
    ldr r3, =hardware_flags
    str r2, [r3]
    
    @ Write register (offset +4096 bytes = 0x1000)
    add r2, r1, #4096
    ldr r3, =write_register
    str r2, [r3]
    
    @ Instruction register (offset +256 bytes = 0x100)
    add r2, r1, #256
    ldr r3, =instruction_reg
    str r2, [r3]
    
    @ Data output register (base address)
    ldr r3, =data_output
    str r1, [r3]
    
    @ Retornar file descriptor como sucesso
    ldr r3, =file_descriptor
    ldr r0, [r3]

cleanup_and_return:
    mov sp, r7
    pop {r7, pc}

@ ----------------------------------------------------------------------------
@ send_element: Envia elemento para processamento no hardware
@
@ Constrói uma instrução personalizada combinando:
@ - Valor do elemento (8 bits)
@ - Índices i e j para posicionamento
@ - Código de operação
@
@ Parâmetros:
@   r0: value (8-bit signed)
@   r1: i (índice linha)
@   r2: j (índice coluna) 
@   r3: opcode (código operação)
@ ----------------------------------------------------------------------------
    .global send_element
    .thumb_func
send_element:
    push {r7}
    sub sp, sp, #28
    add r7, sp, #0
    
    @ Salvar parâmetros no stack frame
    strb r0, [r7, #15]      @ value (8 bits)
    str r1, [r7, #8]        @ i
    str r2, [r7, #4]        @ j  
    str r3, [r7, #0]        @ opcode

build_instruction_word:
    @ Construir palavra de instrução de 32 bits:
    @ Bits 31-18: value (signed, 8 bits shifted left 10)
    @ Bits 17-11: i (7 bits shifted left 7) 
    @ Bits 10-4:  j (7 bits shifted left 4)
    @ Bits 3-0:   opcode (4 bits)
    
    ldrsb r3, [r7, #15]     @ Carregar value como signed byte
    lsl r2, r3, #10         @ value << 10
    
    ldr r3, [r7, #8]        @ Carregar i
    lsl r3, r3, #7          @ i << 7
    orr r2, r2, r3          @ Combinar com value
    
    ldr r3, [r7, #4]        @ Carregar j
    lsl r3, r3, #4          @ j << 4
    orr r2, r2, r3          @ Combinar com resultado anterior
    
    ldr r3, [r7, #0]        @ Carregar opcode
    orr r3, r3, r2          @ Combinar todos os campos
    str r3, [r7, #20]       @ Salvar instrução completa

send_instruction_to_hardware:
    @ 1. Limpar write register (preparar para nova operação)
    ldr r3, =write_register
    ldr r3, [r3]
    mov r2, #0
    str r2, [r3]
    
    @ 2. Escrever instrução no registro de instruções
    ldr r3, =instruction_reg
    ldr r3, [r3]
    ldr r2, [r7, #20]       @ Carregar instrução construída
    str r2, [r3]
    
    @ 3. Ativar processamento (write register = 1)
    ldr r3, =write_register
    ldr r3, [r3]
    mov r2, #1
    str r2, [r3]

wait_for_completion:
    @ loop no flag register até hardware sinalizar conclusão
    ldr r3, =hardware_flags
    ldr r3, [r3]
    ldr r3, [r3]
    cmp r3, #0
    beq wait_for_completion
    
    @ Limpar write register após conclusão
    ldr r3, =write_register
    ldr r3, [r3]
    mov r2, #0
    str r2, [r3]

    add r7, r7, #28
    mov sp, r7
    pop {r7}
    bx lr

@ ----------------------------------------------------------------------------
@ execute_operation: Executa operação genérica no hardware
@
@ Função simplificada para executar operações que não precisam de
@ dados estruturados como send_element 
@ Usada nas operações aritimiteca apenas com matrizes 
@
@ Parâmetros:
@   r0: opcode da operação
@ ----------------------------------------------------------------------------
    .global execute_operation
    .thumb_func
execute_operation:
    push {r7}
    sub sp, sp, #12
    add r7, sp, #0
    
    str r0, [r7, #4]        @ Salvar opcode

send_opcode:
    @ Enviar opcode diretamente para registro de instruções
    ldr r3, =instruction_reg
    ldr r3, [r3]
    ldr r2, [r7, #4]
    str r2, [r3]

wait_execution_complete:
    @ Aguardar conclusão da operação
    ldr r3, =hardware_flags
    ldr r3, [r3]
    ldr r3, [r3]
    cmp r3, #0
    beq wait_execution_complete

    add r7, r7, #12
    mov sp, r7
    pop {r7}
    bx lr

@ ----------------------------------------------------------------------------
@ mult_escalar: Operação de multiplicação escalar
@
@ Implementa multiplicação por escalar usando instrução especializada.
@ O valor escalar é codificado na instrução junto com opcode .
@
@ Parâmetros:
@   r0: escalar (8-bit signed value)
@ ----------------------------------------------------------------------------
    .global mult_escalar
    .thumb_func
mult_escalar:
    push {r7}
    sub sp, sp, #20
    add r7, sp, #0
    
    strb r0, [r7, #7]       @ Salvar escalar como byte

build_scalar_instruction:
    @ Construir instrução: (escalar << 3) | 0x5
    @ Opcode 5 = multiplicação escalar
    ldrsb r3, [r7, #7]      @ Carregar escalar como signed
    and r3, r3, #0xFF       @ Aplicar máscara de 8 bits
    lsl r3, r3, #3          @ Shift escalar para posição correta
    orr r3, r3, #5          @ Combinar com opcode 5
    str r3, [r7, #12]       @ Salvar instrução

execute_scalar_multiply:
    @ Enviar instrução para hardware
    ldr r3, =instruction_reg
    ldr r3, [r3]
    ldr r2, [r7, #12]
    str r2, [r3]

wait_scalar_complete:
    @ Aguardar conclusão
    ldr r3, =hardware_flags
    ldr r3, [r3]
    ldr r3, [r3]
    cmp r3, #0
    beq wait_scalar_complete

    add r7, r7, #20
    mov sp, r7
    pop {r7}
    bx lr



@ ----------------------------------------------------------------------------
@ result: Lê resultado de posição específica
@
@ Solicita ao hardware o valor armazenado na posição [i][j]
@ e retorna o resultado como signed byte.
@
@ Parâmetros:
@   r0: i (índice linha)
@   r1: j (índice coluna)
@
@ Retorno:
@   r0: valor lido (signed byte)
@ ----------------------------------------------------------------------------
    .global result
    .thumb_func
result:
    push {r7}
    sub sp, sp, #12
    add r7, sp, #0
    
    str r0, [r7, #4]        @ Salvar i
    str r1, [r7, #0]        @ Salvar j

build_read_instruction:
    @ Construir instrução de leitura:
    @ (i << 6) | (j << 3) | 0x1
    @ Opcode 1 = operação de leitura
    ldr r2, [r7, #4]        @ Carregar i
    lsl r1, r2, #6          @ i << 6
    
    ldr r2, [r7, #0]        @ Carregar j  
    lsl r2, r2, #3          @ j << 3
    orr r2, r2, r1          @ Combinar i e j
    
    orr r2, r2, #1          @ Adicionar opcode 1 (read)

send_read_request:
    @ Enviar instrução de leitura
    ldr r3, =instruction_reg
    ldr r3, [r3]
    str r2, [r3]

wait_read_complete:
    @ Aguardar conclusão da leitura
    ldr r3, =hardware_flags
    ldr r3, [r3]
    ldr r3, [r3]
    cmp r3, #0
    beq wait_read_complete

read_result_data:
    @ Ler resultado do registro de dados
    ldr r3, =data_output
    ldr r3, [r3]
    ldrb r3, [r3]           @ Carregar byte do resultado
    uxtb r3, r3             @ Zero-extend para 32 bits
    sxtb r3, r3             @ Sign-extend para preservar sinal
    mov r0, r3              @ Retornar em r0

    add r7, r7, #12
    mov sp, r7
    pop {r7}
    bx lr

@ ----------------------------------------------------------------------------
@ exit_program: Limpeza e encerramento
@
@ Libera recursos alocados:
@ - Desfaz memory mapping
@ - Fecha file descriptor
@ ----------------------------------------------------------------------------
    .global exit_program
    .thumb_func
exit_program:
    push {r7, lr}
    add r7, sp, #0

unmap_memory:
    @ Desfazer mapeamento de memória
    ldr r3, =virtual_base
    ldr r0, [r3]            @ Endereço virtual base
    mov r1, #20480          @ Tamanho mapeado
    bl munmap

close_device:
    @ Fechar /dev/mem
    ldr r3, =file_descriptor
    ldr r0, [r3]
    bl close
    
    mov r0, #0              @ Retorno de sucesso
    pop {r7, pc}



	