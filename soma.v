module soma #(parameter tamanho = 5 ,parameter  m2  = 4);

reg [7:0] c [0:tamanho-1][0:tamanho-1];
reg [7:0] a [0:tamanho-1][0:tamanho-1];
reg [7:0] b [0:tamanho-1][0:tamanho-1];
 
integer i, j;

   
    always @ (tamanho) begin
        
        for (i = 0; i < tamanho; i = i + 1) begin
            for (j = 0; j < tamanho; j = j + 1) begin
                a[i][j] = m2;
                b[i][j] = m2;  
            end
        end
    end


    always @ (tamanho) begin
    for (i = 0; i < tamanho; i = i + 1) begin
        for (j = 0; j < tamanho; j = j + 1) begin
            c[i][j] = a[i][j] + b[i][j];
             $write("0x%0h ", c[i][j]); 
          end
          $display(""); 
        end
      end


endmodule