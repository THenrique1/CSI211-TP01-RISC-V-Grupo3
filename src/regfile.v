`timescale 1ns/1ps
module RegFile(
  input         clk,
  input         we,      // write enable
  input  [4:0]  rs1,
  input  [4:0]  rs2,
  input  [4:0]  rd,
  input  [31:0] wd,      // write data
  output [31:0] rd1,
  output [31:0] rd2
);
  reg [31:0] regs [0:31];
  integer i;
  initial begin
    for (i=0;i<32;i=i+1) regs[i] = 32'b0;
    regs[0] = 32'b0; // x0 fixo em zero
  end

  // leituras (combinacionais)
  assign rd1 = (rs1==5'd0) ? 32'b0 : regs[rs1];
  assign rd2 = (rs2==5'd0) ? 32'b0 : regs[rs2];

  // escrita (sincrona)
  always @(posedge clk) begin
    if (we && rd != 5'd0) regs[rd] <= wd;
    regs[0] <= 32'b0; // garante x0=0 sempre
  end
endmodule
