
module Coprocessador(

	input clk, 
	input start, // buttom
	
	 output led_0, 
    output led_1, 
    output led_2
);


wire [2:0] state ;

// maquina de controle principal 
ControlUnit (
	clk,
	start,
	led_0, // leds de representaçao dos estados 
	led_1,
	led_2
);

endmodule 