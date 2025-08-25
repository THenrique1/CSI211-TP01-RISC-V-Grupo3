`timescale 1ns/1ps
module tb_alu;
  reg [31:0] A, B;
  reg [2:0]  op;
  wire [31:0] Y;
  wire Zero;

  ALU dut(.A(A), .B(B), .ALUCtrl(op), .Y(Y), .Zero(Zero));

  task show; input [255:0] msg;
    begin #1 $display("%s: A=%0d B=%0d Y=%0d Zero=%b", msg, A, B, Y, Zero); end
  endtask

  initial begin
    $display("=== Teste ALU ===");
    A=7;  B=5;  op=3'd0; show("ADD");         // 12
    A=7;  B=7;  op=3'd1; show("SUB->Zero=1"); // 0  Zero=1
    A=14; B=14; op=3'd2; show("XOR->Zero=1"); // 0  Zero=1
    A=7;  B=1;  op=3'd3; show("SLL");         // 14
    $finish;
  end
endmodule
