module MUX
( 
    input      [1:0]  sel,
    output reg [7:0]  dataout,
    input      [31:0] datain
);
    always @*
    begin
        case( sel )
            2'b00: dataout = datain[7:0] ;
            2'b01: dataout = datain[15:8] ;
            2'b10: dataout = datain[23:16] ;
            2'b11: dataout = datain[31:24] ;
        endcase
    end

endmodule
