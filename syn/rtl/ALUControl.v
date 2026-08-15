// Verilog project: Verilog code for 16-bit MIPS Processor
// Submodule: ALU Control Unit in Verilog 
 module ALUControl( ALU_Control, ALUOp, Function);  
 output reg[2:0] ALU_Control;  
 input [1:0] ALUOp;  
 input [3:0] Function;  
 wire [5:0] ALUControlIn;  
 assign ALUControlIn = {ALUOp,Function};  
 always @(ALUControlIn)  
 /*casex (ALUControlIn)  
  6'b11xxxx: ALU_Control=3'b000;  
  6'b10xxxx: ALU_Control=3'b100;  
  6'b01xxxx: ALU_Control=3'b001;  
  6'b000000: ALU_Control=3'b000;  
  6'b000001: ALU_Control=3'b001;  
  6'b000010: ALU_Control=3'b010;  
  6'b000011: ALU_Control=3'b011;  
  6'b000100: ALU_Control=3'b100;  
  default: ALU_Control=3'b000;  
*/  

case (ALUControlIn)  
 6'b110000: ALU_Control = 3'b000;
6'b110001: ALU_Control = 3'b000;
6'b110010: ALU_Control = 3'b000;
6'b110011: ALU_Control = 3'b000;
6'b110100: ALU_Control = 3'b000;
6'b110101: ALU_Control = 3'b000;
6'b110110: ALU_Control = 3'b000;
6'b110111: ALU_Control = 3'b000;
6'b111000: ALU_Control = 3'b000;
6'b111001: ALU_Control = 3'b000;
6'b111010: ALU_Control = 3'b000;
6'b111011: ALU_Control = 3'b000;
6'b111100: ALU_Control = 3'b000;
6'b111101: ALU_Control = 3'b000;
6'b111110: ALU_Control = 3'b000;
6'b111111: ALU_Control = 3'b000; 
6'b100000: ALU_Control = 3'b100;
6'b100001: ALU_Control = 3'b100;
6'b100010: ALU_Control = 3'b100;
6'b100011: ALU_Control = 3'b100;
6'b100100: ALU_Control = 3'b100;
6'b100101: ALU_Control = 3'b100;
6'b100110: ALU_Control = 3'b100;
6'b100111: ALU_Control = 3'b100;
6'b101000: ALU_Control = 3'b100;
6'b101001: ALU_Control = 3'b100;
6'b101010: ALU_Control = 3'b100;
6'b101011: ALU_Control = 3'b100;
6'b101100: ALU_Control = 3'b100;
6'b101101: ALU_Control = 3'b100;
6'b101110: ALU_Control = 3'b100;
6'b101111: ALU_Control = 3'b100;
6'b010000: ALU_Control = 3'b001;
6'b010001: ALU_Control = 3'b001;
6'b010010: ALU_Control = 3'b001;
6'b010011: ALU_Control = 3'b001;
6'b010100: ALU_Control = 3'b001;
6'b010101: ALU_Control = 3'b001;
6'b010110: ALU_Control = 3'b001;
6'b010111: ALU_Control = 3'b001;
6'b011000: ALU_Control = 3'b001;
6'b011001: ALU_Control = 3'b001;
6'b011010: ALU_Control = 3'b001;
6'b011011: ALU_Control = 3'b001;
6'b011100: ALU_Control = 3'b001;
6'b011101: ALU_Control = 3'b001;
6'b011110: ALU_Control = 3'b001;
6'b011111: ALU_Control = 3'b001;
  6'b000000: ALU_Control=3'b000;  
  6'b000001: ALU_Control=3'b001;  
  6'b000010: ALU_Control=3'b010;  
  6'b000011: ALU_Control=3'b011;  
  6'b000100: ALU_Control=3'b100;  
  default: ALU_Control=3'b000;  
endcase  
 endmodule  
