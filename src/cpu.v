`timescale 1ns/1ps

module CPU(
  input clk,          // Clock do processador
  input reset        // Reset para inicializar o processador
);

  // -------------------------------------------------
  // Declaração dos registradores e sinais
  // -------------------------------------------------

  reg [31:0] PC;        // Registrador de Contador de Programa (PC)
  wire [31:0] instr;    // Instrução a ser executada

  // Imediatos (I, S, B) extraídos da instrução
  wire [31:0] immI, immS, immB;

  // Campos da instrução
  wire [4:0] rs1 = instr[19:15];  // Registrador de origem 1
  wire [4:0] rs2 = instr[24:20];  // Registrador de origem 2
  wire [4:0] rd  = instr[11:7];   // Registrador de destino

  // Sinais de controle para a unidade de controle
  wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch, BranchNE;
  wire [2:0] ALUCtrl;  // Controle da ALU (Operações como ADD, SUB, etc.)

  // Dados
  wire [31:0] rd1, rd2, aluY, memRData;
  wire Zero;  // Sinal de zero da ALU

  // Definindo a entrada B para a ALU (com base no tipo de operação)
  wire [31:0] aluB = ALUSrc ? (MemWrite ? immS : immI) : rd2;

  // -------------------------------------------------
  // Instância dos módulos
  // -------------------------------------------------

  IMem    u_imem   (.addr(PC),   .instr(instr));  // Memória de Instruções (IMem)

  ImmGen  u_immgen (.instr(instr), .immI(immI), .immS(immS), .immB(immB));  // Gerador de Imediatos (ImmGen)

  RegFile u_reg    (.clk(clk), .we(RegWrite), .rs1(rs1), .rs2(rs2), .rd(rd),
                    .wd(MemToReg ? memRData : aluY), .rd1(rd1), .rd2(rd2));  // Banco de Registradores (RegFile)

  ALU     u_alu    (.A(rd1), .B(aluB), .ALUCtrl(ALUCtrl), .Y(aluY), .Zero(Zero));  // Unidade Lógica e Aritmética (ALU)

  DMem    u_dmem   (.clk(clk), .memRead(MemRead), .memWrite(MemWrite),
                    .addr(aluY), .wdata(rd2), .rdata(memRData));  // Memória de Dados (DMem)

  Control u_ctrl   (.instr(instr), .RegWrite(RegWrite), .MemRead(MemRead),
                    .MemWrite(MemWrite), .MemToReg(MemToReg), .ALUSrc(ALUSrc),
                    .Branch(Branch), .BranchNE(BranchNE), .ALUCtrl(ALUCtrl));  // Unidade de Controle (Control)

  // -------------------------------------------------
  // Lógica do próximo PC
  // -------------------------------------------------

  wire [31:0] PCPlus4  = PC + 32'd4;  // Incremento do PC (PC + 4)
  wire takeBr = Branch & (BranchNE ? (~Zero) : Zero);  // Decisão de tomar o desvio
  wire [31:0] PCTarget = PC + immB;  // Cálculo do endereço de desvio (Branch)
  wire [31:0] PCNext = takeBr ? PCTarget : PCPlus4;  // PC do próximo ciclo (se desviar ou seguir PC+4)

  // -------------------------------------------------
  // Sequencial: Atualiza o PC a cada ciclo de clock
  // -------------------------------------------------

  always @(posedge clk or posedge reset) begin
    if (reset) 
      PC <= 32'b0;  // Se resetar, PC vai para 0
    else 
      PC <= PCNext;  // Caso contrário, atualiza o PC para o próximo valor
  end

endmodule
