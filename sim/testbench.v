`timescale 1ns/1ps
module testbench;
    reg clk   = 0;
    reg reset = 1;

    // clock de 10 ns (100 MHz)
    always #5 clk = ~clk;

    // DUT: nome do módulo em MAIÚSCULO (CPU)
    CPU dut (
        .clk  (clk),
        .reset(reset)
    );

    initial begin
        // segura reset por alguns ciclos
        repeat (5) @(posedge clk);
        reset = 0;

        // roda a CPU por um tempo
        repeat (300) @(posedge clk);
        $finish;
    end

    // dump de ondas para documentação (GTKWAVE)
    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, testbench);
    end
endmodule