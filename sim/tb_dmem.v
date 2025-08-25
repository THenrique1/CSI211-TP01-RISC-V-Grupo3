`timescale 1ns/1ps
module tb_dmem;
  reg clk=0;
  reg memRead=0, memWrite=0;
  reg [31:0] addr=0, wdata=0;
  wire [31:0] rdata;

  DMem dut(.clk(clk), .memRead(memRead), .memWrite(memWrite),
           .addr(addr), .wdata(wdata), .rdata(rdata));

  always #5 clk = ~clk;

  task write_word;
    input [31:0] a, d;
    begin
      @(posedge clk);
      addr=a; wdata=d; memWrite=1; memRead=0;
      @(posedge clk);
      memWrite=0;
    end
  endtask

  task read_word;
    input [31:0] a;
    begin
      addr=a; memRead=1; #1;
      $display("READ [0x%0h] = 0x%08h", a, rdata);
    end
  endtask

  integer i;
  initial begin
    $display("=== Teste DMem ===");
    // escreve em 0, 4, 8
    write_word(32'd0,  32'hAAAA_BBBB);
    write_word(32'd4,  32'hCCCC_DDDD);
    write_word(32'd8,  32'h0000_0007);

    // lê e confere
    read_word(32'd0);
    read_word(32'd4);
    read_word(32'd8);

    // dump das 8 primeiras palavras
    $display("Dump inicial [0..7]:");
    for (i=0;i<8;i=i+1) begin
      addr = i*4; #1 $display("DMEM[%0d] = 0x%08h", i*4, dut.mem[i]);
    end
    $finish;
  end
endmodule
