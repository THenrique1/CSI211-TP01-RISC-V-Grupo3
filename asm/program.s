# Programa de teste da CPU RISC-V

addi x2, x0, 7        # x2 = 7
sw   x2, 4(x0)        # Mem[4] = 7

lw   x1, 4(x0)        # x1 = Mem[4] = 7
add  x3, x1, x2       # x3 = x1 + x2 = 7 + 7 = 14
sw   x3, 0(x0)        # Mem[0] = x3 = 14

addi x4, x0, 14       # x4 = 14
bne  x3, x4, FAIL     # Se x3 != x4, vai para FAIL

# Mais operações de teste

FAIL:
