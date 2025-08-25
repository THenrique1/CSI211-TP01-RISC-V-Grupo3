`timescale 1ns/1ps
module ImmGen(
  input  [31:0] instr,
  output [31:0] immI,  // I-type: addi/lw
  output [31:0] immS,  // S-type: sw
  output [31:0] immB   // B-type: bne
);
  // I: [31:20]
  wire [31:0] I = {{20{instr[31]}}, instr[31:20]};
  // S: [31:25] [11:7]
  wire [31:0] S = {{20{instr[31]}}, instr[31:25], instr[11:7]};
  // B: [31] [7] [30:25] [11:8] [0]=0
  wire [31:0] B = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

  assign immI = I;
  assign immS = S;
  assign immB = B;
endmodule
