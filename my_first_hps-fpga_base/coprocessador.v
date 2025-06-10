module coprocessador(instruction,clk, wr, dataOut, incorrect_addr_flag, overflow_flag, done_flag);
	
	//instruções da unidade de controle
	parameter LOAD = 3'b001; //ler dados de uma matriz
    parameter STORE = 3'b010; //escrever dados em uma matriz
    parameter ADD = 3'b011; //realizar a operaçao de soma
    parameter SUB = 3'b100; //realizar a operaçao de subtraçao
    parameter MULE = 3'b101; //realizar a operaçao de multiplicaçao escalar
    parameter MULM = 3'b110; //realizar a operaçao de multiplicaçao entre matrizes
    parameter NOP = 3'b000; // nao realizar nenhuma operaçao
	parameter RST = 3'b111; //resetar o sistema
	
	input [17:0] instruction;
	input clk, wr;

	//to debug
	
	output reg [7:0] dataOut;
	wire [199:0] dataMatA, dataMatB;
	wire [13:0] dataToA, dataToB;
	wire  wrA, wrB;
	wire [199:0] dataToOut;

	
	wire [7:0] Esc;
	wire ulaDone;

	reg [1:0] ulaOp;
	reg wrOut, en;
	reg [2:0] done;
	reg [2:0] count_clk;
	reg rstOut, clearA, clearB;
	output reg incorrect_addr_flag;
	output overflow_flag;
	output done_flag;
	wire [7:0] dataInC;

	assign done_flag = |done;
	

	always @(posedge clk) begin
		clearA <= 1'b0;
		clearB <= 1'b0;
		rstOut <= 1'b0;
		case (instruction[2:0])
			NOP: begin
				ulaOp <= ulaOp;
				en <= en;
				count_clk <= count_clk;
				wrOut <= wrOut;
	
				incorrect_addr_flag <= incorrect_addr_flag;
			end
			LOAD: begin
				rstOut <= 1'b0;
				en <= 1'b0;
				done <= 3'b000;
				if (instruction[5:3] > 3'b100 || instruction[8:6] > 3'b100) begin
					incorrect_addr_flag <= 1'b1;
				end else begin
					incorrect_addr_flag <= 1'b0;
				end
				if (count_clk == 3'b101) begin
					dataOut <= dataInC;
					done <= 3'b001;
					count_clk <= 3'b000;
				end else count_clk <= count_clk + 1;
			end
			STORE: begin
				done <= 3'b000;
				//rstOut <= 1'b1;
				if (instruction[6:4] > 3'b100 || instruction[9:7] > 3'b100) begin
					incorrect_addr_flag <= 1'b1;
				end else begin
					incorrect_addr_flag <= 1'b0;
				end
				if (count_clk == 3'b101) begin
					done <= 3'b010;
					count_clk <= 3'b000;
				end else begin
					count_clk <= count_clk + 1;
				end
			end
			ADD: begin
				//rstOut <= 1'b1;
				ulaOp <= 2'b00;
				done <= 3'b000;
				en <= 1'b1;
				if (ulaDone) begin
					en <= 1'b0;
					rstOut <= 1'b0;
					count_clk <= count_clk + 1;
					wrOut <= 1'b1;
				end
				if (count_clk > 3'b000) begin
					if (count_clk == 3'b011) begin
						wrOut <= 1'b0;
						count_clk <= 3'b0;
						done <= 3'b100;
					end else begin
						count_clk <= count_clk + 1;
					end
				end
			end
			SUB: begin
				//rstOut <= 1'b1;
				ulaOp <= 2'b01;
				done <= 3'b000;
				en <= 1'b1;
				if (ulaDone) begin
					en <= 1'b0;
					rstOut <= 1'b0;
					count_clk <= count_clk + 1;
					wrOut <= 1'b1;
				end
				if (count_clk > 3'b000) begin
					if (count_clk == 3'b011) begin
						wrOut <= 1'b0;
						count_clk <= 3'b0;
						done <= 3'b100;
					end else begin
						count_clk <= count_clk + 1;
					end
				end
			end
			MULE: begin
				//rstOut <= 1'b1;
				ulaOp <= 2'b10;
				done <= 3'b000;
				en <= 1'b1;
				if (ulaDone) begin
					en <= 1'b0;
					rstOut <= 1'b0;
					count_clk <= count_clk + 1;
					wrOut <= 1'b1;

				end
				if (count_clk > 3'b000) begin
					if (count_clk == 3'b011) begin
						wrOut <= 1'b0;
						count_clk <= 3'b0;
						done <= 3'b100;
					end else begin
						count_clk <= count_clk + 1;
					end
				end
			end
			MULM: begin
				//rstOut <= 1'b1;
				ulaOp <= 2'b11;
				done <= 3'b000;
				en <= 1'b1;
				if (ulaDone) begin
					en <= 1'b0;
					rstOut <= 1'b0;
					count_clk <= count_clk + 1;
					wrOut <= 1'b1;

				end
				if (count_clk > 3'b000) begin
					if (count_clk == 3'b011) begin
						wrOut <= 1'b0;
						count_clk <= 3'b0;
						done <= 3'b100;
					end else begin
						count_clk <= count_clk + 1;
					end
				end
			end
			3'b111: begin
				clearA <= 1'b1;
				clearB <= 1'b1;
				rstOut <= 1'b1;
				count_clk <= count_clk + 1;
				
				if (count_clk == 3'b011) begin
					done <= 3'b100;
				end
			end
			default: begin
				done <= 3'b000;
				ulaOp <= ulaOp;
				count_clk <= count_clk;
				en <= en;
				done <= done;
				wrOut <= wrOut;
				incorrect_addr_flag <= incorrect_addr_flag;
			end
		endcase

	end

	//mini-demux
	assign wrA = ((|dataToA) & wr);
	assign wrB = ((|dataToB) & wr);
	assign Esc = (instruction[2:0] == 3'b101) ? instruction[10:3]: 8'b00000000;

	//estagio de carga
	//modulos
	demux1b demux1b0 (
		.s(instruction[3]),
		.dataIn(instruction[17:4]),
		.dataOut1(dataToA),
		.dataOut2(dataToB)
	);

	registerBank25 matA(
		.clk(clk),
		.dataIn(dataToA),
		.clear(clearA),
		.write(wrA),
		.dataOut(dataMatA)

	);
	registerBank25 matB(
		.clk(clk),
		.dataIn(dataToB),
		.clear(clearB),
		.write(wrB),
		.dataOut(dataMatB)
	);

	//estagio de realização de operação
	ula ULA(
		.MatA(dataMatA),
		.MatB(dataMatB),
		.Esc(Esc),
		.Op(ulaOp),
		.Mat0(dataToOut),
		.Overflow(overflow_flag),
		.clk(clk),
		.en(en),
		.done(ulaDone)
	);

	//estagio de write back
	regOut matC(
		.clk(clk),
		.dataIn(dataToOut),
		.rst(rstOut),
		.addr(instruction[8:3]),
		.write(wrOut),
		.data(dataInC)
	);
endmodule