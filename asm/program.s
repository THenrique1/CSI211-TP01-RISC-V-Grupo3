# Programa de teste — offsets de branch em BYTES (8 = 2 instruções)

addi x2,x0,7          # x2 <- 7
sw   x2,4(x0)         # Mem[4] <- 7
lw   x1,4(x0)         # x1 <- Mem[4] (=7)
add  x2,x1,x0         # x2 <- 7
addi x3,x2,10         # x3 <- 17
add  x4,x3,x2         # x4 <- 24
add  x5,x2,x0         # x5 <- 7
addi x6,x5,3          # x6 <- 10
bne  x6,x5,8          # 10 != 7 → salta 8 bytes (2 instr)
add  x7,x6,x6         # (executa só se NÃO saltar) x7 <- 20
sw   x7,0(x0)         # (executa só se NÃO saltar) Mem[0] <- 20
# Caminho do salto (executado aqui porque x6 != x5)
add  x9,x5,x0         # x9 <- 7 (mv usando ADD)
sw   x9,0(x0)         # Mem[0] <- 7 (resultado final)
