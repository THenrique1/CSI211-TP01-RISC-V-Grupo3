`timescale 1ns/1ps
module tb_immgen;
  reg  [31:0] instr;
  wire [31:0] immI, immS, immB;

  ImmGen dut(.instr(instr), .immI(immI), .immS(immS), .immB(immB));

  // OPCODES
  localparam OPIMM  = 7'b0010011; // I-type (ex: ADDI)
  localparam LOAD   = 7'b0000011; // I-type (ex: LW)
  localparam STORE  = 7'b0100011; // S-type (ex: SW)
  localparam BRANCH = 7'b1100011; // B-type (ex: BNE)

  // Função para montar I-type: imm[11:0], rs1, funct3, rd, opcode
  function [31:0] mkI;
    input signed [11:0] imm12;
    input [4:0] rs1, rd;
    input [2:0] funct3;
    input [6:0] opcode;
    begin
      mkI = {imm12[11:0], rs1, funct3, rd, opcode};
    end
  endfunction

  // Função para montar S-type: imm[11:5], rs2, rs1, funct3, imm[4:0], opcode
  function [31:0] mkS;
    input signed [11:0] imm12;
    input [4:0] rs1, rs2;
    input [2:0] funct3;
    input [6:0] opcode;
    begin
      mkS = {imm12[11:5], rs2, rs1, funct3, imm12[4:0], opcode};
    end
  endfunction

  // Função para montar B-type: imm[12|10:5|4:1|11] (com bit 0 = 0)
  function [31:0] mkB;
    input signed [12:0] imm13; // múltiplo de 2 (bit 0 = 0)
    input [4:0] rs1, rs2;
    input [2:0] funct3;
    input [6:0] opcode;
    reg [12:0] t;
    begin
      // garantir alinhamento (bit 0 sempre 0 em branches)
      t = imm13;
      mkB = { t[12], t[10:5], rs2, rs1, funct3, t[4:1], t[11], opcode };
    end
  endfunction

  task checkI; input [31:0] exp; begin
    #1 $display("I  imm = 0x%08h (%0d)  [exp=0x%08h]", immI, $signed(immI), exp);
  end endtask
  task checkS; input [31:0] exp; begin
    #1 $display("S  imm = 0x%08h (%0d)  [exp=0x%08h]", immS, $signed(immS), exp);
  end endtask
  task checkB; input [31:0] exp; begin
    #1 $display("B  imm = 0x%08h (%0d)  [exp=0x%08h]", immB, $signed(immB), exp);
  end endtask

  initial begin
    $display("=== Teste ImmGen ===");

    // 1) I-type (ADDI x1, x0, +7)  -> immI = +7
    instr = mkI(12'sd7, 5'd0, 5'd1, 3'b000, OPIMM);
    checkI(32'h00000007);

    // 2) I-type (LW x2, 0(x0))     -> immI = 0
    instr = mkI(12'sd0, 5'd0, 5'd2, 3'b010, LOAD);
    checkI(32'h00000000);

    // 3) S-type (SW x1, 4(x0))     -> immS = +4
    instr = mkS(12'sd4, 5'd0, 5'd1, 3'b010, STORE);
    checkS(32'h00000004);

    // 4) B-type (BNE x3, x4, +8)   -> immB = +8
    instr = mkB(13'sd8, 5'd3, 5'd4, 3'b001, BRANCH);
    checkB(32'h00000008);

    // 5) B-type (BNE x3, x4, -4)   -> immB = 0xFFFFFFFC (-4)
    instr = mkB(-13'sd4, 5'd3, 5'd4, 3'b001, BRANCH);
    checkB(32'hFFFFFFFC);

    // 6) I-type negativo (ADDI x5, x5, -1) -> immI = 0xFFFFFFFF (-1)
    instr = mkI(-12'sd1, 5'd5, 5'd5, 3'b000, OPIMM);
    checkI(32'hFFFFFFFF);

    $finish;
  end
endmodule
