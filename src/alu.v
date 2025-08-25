`timescale 1ns/1ps
module ALU(
  input  [31:0] A,
  input  [31:0] B,
  input  [2:0]  ALUCtrl, // 0:ADD, 1:SUB, 2:XOR, 3:SLL
  output reg [31:0] Y,
  output Zero
);
  always @(*) begin
    case (ALUCtrl)
      3'd0: Y = A + B;
      3'd1: Y = A - B;
      3'd2: Y = A ^ B;
      3'd3: Y = A << (B[4:0]);
      default: Y = 32'b0;
    endcase
  end
  assign Zero = (Y == 32'b0);
endmodule
