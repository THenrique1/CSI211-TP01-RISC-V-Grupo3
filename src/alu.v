`timescale 1ns/1ps
module alu(
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0]  ALUCtrl,      // 0:ADD, 1:SUB, 2:XOR, 3:SLL, 4:BNE
    output reg [31:0] Y,
    output        Zero
);
    always @(*) begin
        case (ALUCtrl)
            3'd0: Y = A + B;                       // ADD
            3'd1: Y = A - B;                       // SUB
            3'd2: Y = A ^ B;                       // XOR
            3'd3: Y = A << B[4:0];                 // SLL
            3'd4: Y = (A != B) ? 32'd1 : 32'd0;    // BNE (flag em Y)
            default: Y = 32'd0;
        endcase
    end
    assign Zero = (Y == 32'd0);
endmodule