`timescale 1ns/1ps
module CPU(
  input clk,
  input reset
);
  reg [31:0] PC;
  wire [31:0] instr;
  wire [31:0] immI, immS, immB;

  // campos da instrução
  wire [4:0] rs1 = instr[19:15];
  wire [4:0] rs2 = instr[24:20];
  wire [4:0] rd  = instr[11:7];

  // sinais de controle
  wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch, BranchNE;
  wire [2:0] ALUCtrl;

  // dados
  wire [31:0] rd1, rd2, aluY, memRData;
  wire Zero;

  // B da ALU: imediato certo conforme o tipo
  wire [31:0] aluB = ALUSrc ? (MemWrite ? immS : immI) : rd2;

  // unidades
  IMem    imem(.addr(PC), .instr(instr));
  ImmGen  immgen(.instr(instr), .immI(immI), .immS(immS), .immB(immB));
  RegFile rf(.clk(clk), .we(RegWrite), .rs1(rs1), .rs2(rs2), .rd(rd),
             .wd(MemToReg ? memRData : aluY), .rd1(rd1), .rd2(rd2));
  ALU     alu(.A(rd1), .B(aluB), .ALUCtrl(ALUCtrl), .Y(aluY), .Zero(Zero));
  DMem    dmem(.clk(clk), .memRead(MemRead), .memWrite(MemWrite),
               .addr(aluY), .wdata(rd2), .rdata(memRData));
  Control ctrl(.instr(instr), .RegWrite(RegWrite), .MemRead(MemRead),
               .MemWrite(MemWrite), .MemToReg(MemToReg), .ALUSrc(ALUSrc),
               .Branch(Branch), .BranchNE(BranchNE), .ALUCtrl(ALUCtrl));

  // próximo PC
  wire [31:0] PCPlus4  = PC + 32'd4;
  wire        takeBr   = Branch & (BranchNE ? (~Zero) : Zero);
  wire [31:0] PCTarget = PC + immB;     // desvio relativo
  wire [31:0] PCNext   = takeBr ? PCTarget : PCPlus4;

  always @(posedge clk or posedge reset) begin
    if (reset) PC <= 32'b0;
    else       PC <= PCNext;
  end
endmodule
