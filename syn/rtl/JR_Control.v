// Verilog project: Verilog code for 16-bit MIPS Processor
// Verilog code for 16 bit single cycle MIPS CPU 
module JR_Control( input[1:0] alu_op, 
input [3:0] funct,
output JRControl
);
assign JRControl = ({alu_op,funct}==6'b001000) ? 1'b1 : 1'b0;

endmodule
