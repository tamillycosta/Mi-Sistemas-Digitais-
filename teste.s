.syntax unified
.arch armv7-a
.arm

.global fpga_comunication


.section .data
mem_path: .asciz "/dev/mem"
msg: .asciz "FPGA value: "
newline: .asciz "\n"


.section .text

fpga_comunication:

    @ guarda o parametro de r0 da função do c
    ldr r1, =num 
    str r0, [r1]

    @--Mapeamento--@

    @ --- open("/dev/mem", O_RDWR | O_SYNC) ---
    ldr r0, =mem_path      @ /dev/mem
    mov r1, #2             @ (modo leitura e escrita)  
    mov r7, #5             @ syscall open
    svc 0                  @ chama o sistema para executar open("/dev/mem", O_RDWR | O_SYNC)
    
   
    @ --- Verificando abertura do arquivo ---
    cmp r0, #0
    blt fail_open      @r0 < 0

  
    @ --- mmap(NULL, 0x1000, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0xFF200000) ---

                           @ r0 = resultado de open 
    ldr r1, =fd_var        @ endereço da variável
    str r0, [r1]           @ salva o valor de fd (r0) na memória

    mov r4, r0
    mov r0, #0            @ addr = NULL
    ldr r1, #1000         @ length
    mov r2, #3            @ PROT_READ | PROT_WRITE
    mov r3, #1            @ MAP_SHARED
    ldr r5, =0xFF200      @axi base  
    mov r7, #192          @ syscall mmap2 
    svc 0


    @ --- Verificando mapeamento da memória ---
    cmp r0, #-1
    beq fail_mmap


    @ --- Salve o Endereço base mapeado ---
    ldr r1, = mapped_address @ponteiro para a variavel mmapped
    str r0, [r1] @ guarda endereço mapeado

           
    @ --- escreve um valor no offset 0x10 e le no ofsset de 0x00 ---
execute:
    ldr r4, =mapped_address
    ldr r2, =num @ pointer do valor de num vindo do c
    ldr r3, [r2] @num

    ldr r4, [r4] @carrega ponteiro para endereço base axy
    add r1, r4, #0x10 @base + ofsset (num)
    add r0, r4, #0x00 @base + ofsset (result)
   
    str r3, [r1] @ envia num
    ldr r0, [r0] @recebe o result 
    bx lr 


fail_open:
    ldr r0, =fail_msg     @ r0 = ponteiro para string
    mov r1, r0            @ r1 = ponteiro para string (para write)
    mov r2, #31           @ tamanho da string
    mov r0, #1            @ stdout
    mov r7, #4            @ syscall write
    svc #0

    mov r0, #1            @ código de saída
    mov r7, #1            @ syscall exit
    svc #0



fail_mmap:
    mov r0, =fail_map_msg
    mov r1,r0
    mov r2, #16
    mov r0, #1
    mov r7, #4
    svc #0

    mov r0, #1
    mov r7, #1
    svc #0



.section .data


    @variaveis 
    fd_var : .word 0
    mapped_address: .word 0
    num: .word 0

/* Error messages */
fail_msg:
    .asciz "Erro: Falha ao abrir /dev/mem\n"

fail_map_msg:
    . .asciz "Erro: MAP_FAILED"