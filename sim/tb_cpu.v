`timescale 1ns/1ps
module tb_cpu;
  reg clk=0, reset=1;
  CPU dut(.clk(clk), .reset(reset));

  integer i;
  always #5 clk = ~clk;   // 100 MHz simbólico

  initial begin
    $display("=== CPU SIM ===");
    #12 reset = 0;

    // roda bastantes ciclos para terminar o programa
    repeat (60) @(posedge clk);

    $display("==== REGISTERS ====");
    for (i=0; i<32; i=i+1)
      $display("x%0d = 0x%08h", i, dut.rf.regs[i]);

    $display("==== DATA MEM[0..31] ====");
    for (i=0; i<32; i=i+1)
      $display("DMEM[%0d] = 0x%08h", i*4, dut.dmem.mem[i]);

    $finish;
  end
endmodule
