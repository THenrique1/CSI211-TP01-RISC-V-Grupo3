`timescale 1ns/1ps
module IMem(
  input  [31:0] addr,   // endereço em bytes
  output [31:0] instr   // palavra (32 bits)
);
  reg [31:0] mem [0:255]; // 256 palavras = 1 KB

  initial begin
    $readmemh("imem.hex", mem); // arquivo com 1 palavra por linha (hex)
  end

  // endereçamento por palavra (ignora 2 LSBs, word-aligned)
  assign instr = mem[addr[31:2]];
endmodule
