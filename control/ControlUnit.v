module ControlUnit (
    input clock, 
    input button, 
    
    output led_0, 
    output led_1, 
    output led_2
);
    reg [2:0] opcode;
	 reg [7:0] tamanho;
    reg [199:0] matrix_a; // 5x5 8-bit matrix +  (opcode e tamanho
    reg [199:0] matrix_b; // 5x5 8-bit matrix
	 reg signed [7:0] escalar;
		
    reg [199:0] data; // dados escritos na memoria
    reg write_enable; 
    reg [2:0] address; 
    reg [2:0] state;
    wire [223:0] out; // dados lidos da memoria
	  
    wire [199:0] result; // 5x5 result matrix
    wire button_stable;

    // instanciação do módulo de memória
    memory mem_inst (
        address,
        clock,
        data,
        write_enable,
        out
    );

    // instanciação do módulo execute
    Execute (
		  clock,
        opcode ,
        matrix_a,
        matrix_b,
        tamanho,
        result
    );

    // debounce do botão
    debounce debounce_inst (
        button,
        clock,
        button_stable
    );

    always @(posedge  button_stable) begin
	
        case (state)
            // fetch: busca os operandos da memória
            3'b000: begin
                write_enable = 0;
                address = 3'b000;
                state = 3'b001;
            end
				
				// deocode = decodifica os dados recebidos da memoria 
            3'b001: begin
					 opcode = out[2:0];
					 tamanho = out[16:8];
					 matrix_a = out[215:16];  
                address = address + 1;
                state = 3'b010;
            end
            3'b010: begin
                matrix_b = out[215:16];
	
                address = address + 1;
                state = 3'b011;
            end
            
        
            3'b011: begin
                write_enable = 0;
                state = 3'b100;
            end
            
            // execute: realiza a operação e escreve o resultado
            3'b100: begin
                data = result;
                write_enable = 1;
                state = 3'b101;
            end
				
            3'b101: begin
                write_enable = 1;
                state = 3'b110;
            end
            3'b110: begin
                write_enable = 0;
                address = 3'b000;
                state = 3'b000; // retorna ao estado inicial
            end
        endcase
		
    end

    assign led_0 = state[0];
    assign led_1 = state[1];
    assign led_2 = state[2];

endmodule