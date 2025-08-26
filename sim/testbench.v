module new_testbench;

     Declaração de registradores e fios
    reg [310] A, B;           Registradores de entrada
    reg [20] ALUCtrl;         Controle da ALU (ADD, SUB, XOR, etc.)
    wire [310] Y;             Saída da ALU
    wire Zero;                 Sinal Zero da ALU

     Instância da ALU
    alu uut (
        .A(A),
        .B(B),
        .ALUCtrl(ALUCtrl),
        .Y(Y),
        .Zero(Zero)
    );

     Instância da Unidade de Controle (control)
    control control_unit (
        .ALUOp(ALUCtrl)
    );

     Teste das operações da ALU (ADD, SUB, XOR, SLL)
    initial begin
         Inicializar os sinais de entrada
        A = 32'h00000000;
        B = 32'h00000001;
        ALUCtrl = 3'b000;   Operação de ADD (exemplo)

         Teste de operação de ADD
        #10 A = 32'h00000002; 
        #10 B = 32'h00000003; 
        #10 ALUCtrl = 3'b000;  ADD
        #10 $display(ADD A = %d, B = %d, Y = %d, Zero = %b, A, B, Y, Zero);

         Teste de operação de SUB
        #10 A = 32'h00000010;
        #10 B = 32'h00000004;
        #10 ALUCtrl = 3'b001;  SUB
        #10 $display(SUB A = %d, B = %d, Y = %d, Zero = %b, A, B, Y, Zero);

         Teste de operação de XOR
        #10 A = 32'h0000000F; 
        #10 B = 32'h000000F0;
        #10 ALUCtrl = 3'b010;  XOR
        #10 $display(XOR A = %d, B = %d, Y = %d, Zero = %b, A, B, Y, Zero);

         Teste de operação de Shift Left Logical (SLL)
        #10 A = 32'h00000001; 
        #10 B = 32'h00000004;
        #10 ALUCtrl = 3'b011;  SLL
        #10 $display(SLL A = %d, B = %d, Y = %d, Zero = %b, A, B, Y, Zero);

         Finaliza o teste após todas as operações
        #20 $finish;
    end

     Função para testar a memória de dados (testa tb_dmem.v)
    initial begin
        $display(Memória de Dados);
        #10 $display(Mem[0] = %h, mem[0]);
        #10 $display(Mem[4] = %h, mem[4]);
        #10 $display(Mem[8] = %h, mem[8]);
    end

     Função para testar a memória de instruções (testa tb_imem.v)
    initial begin
        $display(Memória de Instruções);
        #10 $display(Instrução Mem[0] = %h, instruction_mem[0]);
        #10 $display(Instrução Mem[4] = %h, instruction_mem[4]);
    end

     Função para testar os registradores (testa tb_regfile.v)
    initial begin
        $display(Registradores);
        #10 $display(Registrador x0 = %h, registers[0]);
        #10 $display(Registrador x1 = %h, registers[1]);
        #10 $display(Registrador x2 = %h, registers[2]);
        #10 $display(Registrador x3 = %h, registers[3]);
    end

endmodule
