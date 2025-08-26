`timescale 1ns/1ps

module testbench;
    reg clk   = 0;
    reg reset = 1;

    // clock de 10 ns (100 MHz)
    always #5 clk = ~clk;

    // Instância da CPU (DUT)
    CPU dut (
        .clk  (clk),
        .reset(reset)
    );

    initial begin
        // Ativar o reset por 10 ciclos para garantir que a CPU seja resetada
        repeat (10) @(posedge clk);
        reset = 0;

        // Rodar a CPU por 500 ciclos
        repeat (500) @(posedge clk);
        $finish;
    end

    // Dump de ondas para visualização no GTKWAVE
    initial begin
        $dumpfile("cpu_tb.vcd");  // Nome do arquivo .vcd
        $dumpvars(0, testbench);   // Variáveis que você quer dumpadas
    end

    // Exibir os valores dos registradores para monitoramento
    initial begin
        // Mostra o valor dos registradores da CPU durante a simulação
        $monitor("Time: %t | Register [0]: %d | Register [1]: %d | Register [2]: %d | Register [3]: %d | Register [6]: %d | Register [24]: %d", 
                 $time, dut.dut.regfile.registers[0], dut.dut.regfile.registers[1], 
                 dut.dut.regfile.registers[2], dut.dut.regfile.registers[3], 
                 dut.dut.regfile.registers[6], dut.dut.regfile.registers[24]);
    end
endmodule
