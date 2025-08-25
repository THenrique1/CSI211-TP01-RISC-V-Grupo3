`timescale 1ns/1ps
module Control(
  input  [31:0] instr,
  output        RegWrite,
  output        MemRead,
  output        MemWrite,
  output        MemToReg,
  output        ALUSrc,
  output        Branch,
  output        BranchNE,
  output [2:0]  ALUCtrl
);
  wire [6:0] opcode = instr[6:0];
  wire [2:0] funct3 = instr[14:12];
  wire [6:0] funct7 = instr[31:25];

  reg regwrite_r, memread_r, memwrite_r, memtoreg_r, alusrc_r, branch_r, branchne_r;
  reg [2:0] aluctrl_r;

  localparam OP      = 7'b0110011; // R: add/xor/sll
  localparam OPIMM   = 7'b0010011; // I: addi
  localparam LOAD    = 7'b0000011; // lw
  localparam STORE   = 7'b0100011; // sw
  localparam BRANCH  = 7'b1100011; // bne (funct3=001)

  always @(*) begin
    // defaults
    regwrite_r=0; memread_r=0; memwrite_r=0; memtoreg_r=0;
    alusrc_r=0; branch_r=0; branchne_r=0; aluctrl_r=3'd0;

    case (opcode)
      OP: begin
        regwrite_r = 1; alusrc_r = 0; memtoreg_r = 0;
        case (funct3)
          3'b000: aluctrl_r = 3'd0; // ADD
          3'b100: aluctrl_r = 3'd2; // XOR
          3'b001: aluctrl_r = 3'd3; // SLL
          default: aluctrl_r = 3'd0;
        endcase
      end
      OPIMM: begin
        regwrite_r = 1; alusrc_r = 1; memtoreg_r = 0;
        aluctrl_r  = 3'd0; // ADDI
      end
      LOAD: begin
        regwrite_r = 1; alusrc_r = 1; memread_r  = 1; memtoreg_r = 1;
        aluctrl_r  = 3'd0; // ADD para endereço
      end
      STORE: begin
        alusrc_r   = 1; memwrite_r = 1;
        aluctrl_r  = 3'd0; // ADD para endereço
      end
      BRANCH: begin
        branch_r   = 1;
        branchne_r = (funct3 == 3'b001); // BNE
        alusrc_r   = 0;
        aluctrl_r  = 3'd1; // SUB para comparação
      end
      default: ;
    endcase
  end

  assign RegWrite = regwrite_r;
  assign MemRead  = memread_r;
  assign MemWrite = memwrite_r;
  assign MemToReg = memtoreg_r;
  assign ALUSrc   = alusrc_r;
  assign Branch   = branch_r;
  assign BranchNE = branchne_r;
  assign ALUCtrl  = aluctrl_r;
endmodule
