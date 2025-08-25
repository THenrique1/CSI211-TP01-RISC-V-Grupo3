`timescale 1ns/1ps
module DMem(
  input         clk,
  input         memRead,
  input         memWrite,
  input  [31:0] addr,    // endereço em bytes
  input  [31:0] wdata,   // dado para escrever
  output [31:0] rdata    // dado lido
);
  reg [31:0] mem [0:1023]; // 4 KB (1024 palavras)

  integer i;
  initial begin
    for (i=0;i<1024;i=i+1) mem[i] = 32'b0;
  end

  // leitura combinacional (word-aligned)
  assign rdata = mem[addr[31:2]];

  // escrita síncrona
  always @(posedge clk) begin
    if (memWrite) mem[addr[31:2]] <= wdata;
  end
endmodule
