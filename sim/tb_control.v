`timescale 1ns/1ps
module tb_control;
  reg  [31:0] instr;
  wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch, BranchNE;
  wire [2:0] ALUCtrl;

  Control dut(
    .instr(instr),
    .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
    .MemToReg(MemToReg), .ALUSrc(ALUSrc), .Branch(Branch),
    .BranchNE(BranchNE), .ALUCtrl(ALUCtrl)
  );

  // OPCODES
  localparam OP     = 7'b0110011; // R: add/xor/sll
  localparam OPIMM  = 7'b0010011; // I: addi
  localparam LOAD   = 7'b0000011; // lw
  localparam STORE  = 7'b0100011; // sw
  localparam BRANCH = 7'b1100011; // bne (funct3=001)

  // variáveis para imediatos (para poder fatiar)
  reg [11:0] imm12;
  reg [12:0] imm13;

  initial begin
    $display("=== TB_CONTROL START ===");

    // ADD (R: funct3=000)
    instr = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, OP}; #1;
    $display("ADD  -> RW=%0d MR=%0d MW=%0d M2R=%0d AS=%0d BR=%0d BNE=%0d ALU=%0d",
             RegWrite,MemRead,MemWrite,MemToReg,ALUSrc,Branch,BranchNE,ALUCtrl);

    // XOR (R: funct3=100)
    instr = {7'b0000000, 5'd2, 5'd1, 3'b100, 5'd3, OP}; #1;
    $display("XOR  -> RW=%0d MR=%0d MW=%0d M2R=%0d AS=%0d BR=%0d BNE=%0d ALU=%0d",
             RegWrite,MemRead,MemWrite,MemToReg,ALUSrc,Branch,BranchNE,ALUCtrl);

    // SLL (R: funct3=001)
    instr = {7'b0000000, 5'd2, 5'd1, 3'b001, 5'd3, OP}; #1;
    $display("SLL  -> RW=%0d MR=%0d MW=%0d M2R=%0d AS=%0d BR=%0d BNE=%0d ALU=%0d",
             RegWrite,MemRead,MemWrite,MemToReg,ALUSrc,Branch,BranchNE,ALUCtrl);

    // ADDI (I: funct3=000)
    imm12 = 12'd7;
    instr = {imm12, 5'd1, 3'b000, 5'd3, OPIMM}; #1;
    $display("ADDI -> RW=%0d MR=%0d MW=%0d M2R=%0d AS=%0d BR=%0d BNE=%0d ALU=%0d",
             RegWrite,MemRead,MemWrite,MemToReg,ALUSrc,Branch,BranchNE,ALUCtrl);

    // LW (I: funct3=010)
    imm12 = 12'd0;
    instr = {imm12, 5'd0, 3'b010, 5'd2, LOAD}; #1;
    $display("LW   -> RW=%0d MR=%0d MW=%0d M2R=%0d AS=%0d BR=%0d BNE=%0d ALU=%0d",
             RegWrite,MemRead,MemWrite,MemToReg,ALUSrc,Branch,BranchNE,ALUCtrl);

    // SW (S: funct3=010) – imm = 4  (agora usando variável para poder fatiar)
    imm12 = 12'd4;
    instr = {imm12[11:5], 5'd2, 5'd0, 3'b010, imm12[4:0], STORE}; #1;
    $display("SW   -> RW=%0d MR=%0d MW=%0d M2R=%0d AS=%0d BR=%0d BNE=%0d ALU=%0d",
             RegWrite,MemRead,MemWrite,MemToReg,ALUSrc,Branch,BranchNE,ALUCtrl);

    // BNE (B: funct3=001) – offset 0 (só pra ver sinais)
    imm13 = 13'd0;
    instr = {imm13[12], imm13[10:5], 5'd2, 5'd1, 3'b001, imm13[4:1], imm13[11], BRANCH}; #1;
    $display("BNE  -> RW=%0d MR=%0d MW=%0d M2R=%0d AS=%0d BR=%0d BNE=%0d ALU=%0d",
             RegWrite,MemRead,MemWrite,MemToReg,ALUSrc,Branch,BranchNE,ALUCtrl);

    $display("=== TB_CONTROL DONE ===");
    $finish;
  end
endmodule
