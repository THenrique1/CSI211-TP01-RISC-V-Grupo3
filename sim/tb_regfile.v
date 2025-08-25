`timescale 1ns/1ps
module tb_regfile;
  reg clk=0, we=0;
  reg [4:0] rs1=0, rs2=0, rd=0;
  reg [31:0] wd=0;
  wire [31:0] rd1, rd2;

  RegFile dut(.clk(clk), .we(we), .rs1(rs1), .rs2(rs2), .rd(rd), .wd(wd), .rd1(rd1), .rd2(rd2));

  // clock de 10ns
  always #5 clk = ~clk;

  initial begin
    $display("=== Teste RegFile ===");

    // escreve x1 = 0xA
    @(posedge clk); we=1; rd=5'd1; wd=32'h0000000A;
    @(posedge clk); we=0; rd=0; wd=0;

    // tenta escrever x0 (deve ignorar)
    @(posedge clk); we=1; rd=5'd0; wd=32'hFFFFFFFF;
    @(posedge clk); we=0;

    // lê x1 e x0
    rs1=5'd1; rs2=5'd0; #1;
    $display("x1=%h (esperado 0000000A), x0=%h (esperado 00000000)", rd1, rd2);

    $finish;
  end
endmodule
