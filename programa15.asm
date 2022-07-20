#Programa lê uma matriz NxN e informa se a mesma é ou não permutativa
.data
    ent1: .asciiz "Insira o valor da posicao["
    ent2: .asciiz "]["
    ent3: .asciiz "]: "
    msg_entN: .asciiz "Entre com um valor inteiro(N>1). "
    msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 1. "
    msg_true: .asciiz "Matriz permutativa!"
    msg_false: .asciiz "Matriz nao permutativa!"

.align 2

.text   
    Leitura_N: 
        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_entN        #Armazena em $a0 o endereco da variavel "msg_entN"
        syscall                 #Imprime a mensagem que esta salva em $a0
        li $v0, 5               #Codigo SysCall para ler inteiros
        syscall                 #Chamada de sistema para leitura de inteiro
        ble $v0, 0, Loop_Erro   #Se o valor digitado for menor ou igual que 0 salta para o label Loop_Erro

        add $s0, $v0, $zero     #Armazena em $s0 o valor lido

    Alocacao:
        mul $s1, $s0, $s0       #$s1 recebe o valor de NxN
        mul $s1, $s1, 4         #s1 recebe o valor (Nxn) multiplicado por 4(Espaço ocupado por 1 Byte)
        move $a0, $s1           #$a0 recebe o tamanho total do vetor a ser alocado
        li $v0, 9               #Codigo SysCall de alocação dinamica
        syscall                 #Chamada de sistema para alocação
        move $t0, $v0           #Move $v0 para $t0

    Main:
        move $a0, $t0           #a0 recebe o endereco base da matriz alocada
        move $a1, $s0           #a1 recebe (n) o numero de linhas

        jal Leitura

        move $a0, $v0
        jal Escrita

        li $t8, 1               #Booleano para saber se é pra verificar linhas ou colunas comeca com 1 pois vou verificar as linhas primeiro
        addi $t9, $s0, -1       #t9 recebe n-1
        move $a0, $v0
        jal Verificacao

        li $t8, 0
        move $a0, $v0
        jal Verificacao

        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_true        #Armazena em $a0 a mensagem de saida caso a matriz seja permutativa
        syscall

    Finaliza:
        li $v0,10
        syscall

        Indice:
            mul $v0, $t1, $a1  #i * ncol
            add $v0, $v0, $t2  #i * ncol + j
            sll $v0, $v0, 2    #[(i*ncol) +j ] *4
            add $v0, $v0, $a3
            jr $ra

        Leitura:
            subi $sp, $sp, 4
            sw $ra, ($sp)
            move $a3, $a0       #a3 recebe o endereco base da matriz
            li $t1, 0
            li $t2, 0

            Laco:
                la $a0, ent1
                li $v0, 4
                syscall
                move $a0, $t1
                li $v0, 1
                syscall
                la $a0, ent2
                li $v0, 4
                syscall
                move $a0, $t2
                li $v0, 1
                syscall
                la $a0, ent3
                li $v0, 4
                syscall
                li $v0, 5
                syscall
                move $t3, $v0       #Valor foi lido e esta em t3

                jal Indice          #Calcula a posicao da matriz e armazena em v0
                sw $t3, ($v0)       #Armazena o valor lido na posicao calculada
                addi $t2, $t2, 1    #Incrementa o j
                blt $t2, $a1, Laco  #Se o j é menor q o numero de linhas/colunas da matriz
                li $t2, 0
                addi $t1, $t1, 1    #Incrementa o i
                blt $t1, $a1, Laco  #Se o i é menor q o numero de linhas/colunas da matriz
                li $t1, 0
                lw $ra, ($sp)       #Recupera o endereco do $ra que estava na pilha
                addi $sp, $sp, 4    #Devolve o ponteiro da pilha pro topo
                move $v0, $a3       #Salva o endereco base da matriz em v0
                jr $ra

        Escrita:
            subi $sp, $sp, 4
            sw $ra ($sp)
            move $a3, $a0
            
            Laco_Escrita:
                jal Indice                  #Calcula o v0 de acordo com o indice
                lw $a0, ($v0)               #Carrega em a0 o valor da posicao calculada
                li $v0, 1
                syscall
                la $a0, 32                  #Codigo ascii para espaco
                li $v0, 11
                syscall
                addi $t2, $t2, 1            #j++
                blt $t2, $a1, Laco_Escrita  #Se o j é menor q o numero de linhas/colunas da matriz
                la $a0, 10                  #Codigo ascii para o \n
                syscall
                li $t2, 0                   #j = 0
                addi $t1, $t1, 1            #i++
                blt $t1, $a1, Laco_Escrita  #Se o i for menor que o numero de linhas/colunas salta pro loop novamente
                li $t1, 0       #i = 0 
                lw $ra, ($sp)               #Recupera o endereco do $ra que estava na pilha
                addi $sp, $sp, 4            #Devolve o ponteiro da pilha pro topo
                move $v0, $a3               #Salva o endereco base da matriz em v0
                jr $ra

        Verificacao:
            subi $sp, $sp, 4
            sw $ra ($sp)
            move $a3, $a0
            li $t1, 0
            li $t2, 0
            li $s1, 0
            beq $t8, $zero, LoopColuna

            LoopLinha:
                jal Indice                  #Calcula o v0 de acordo com o indice
                lw $a0, ($v0)               #Carrega em a0 o valor da posicao calculada
                move $t3, $a0
                addi $t2, $t2, 1            #j++
                
                bne $t3, $zero, Nao_Zero
                addi $s1, $s1, 1            #s1 é incrementado em +1 vamos usar pra verificar se a linha possuin n-1 zeros

                Continua:
                blt $t2, $a1, LoopLinha         #Se o j é menor q o numero de colunas da matriz
                bne $s1, $t9, Nao_Permutativa   #Se a linha nao possui n-1 elementos igual a 0 a matriz nao é permutativa
                li $s1, 0

                li $t2, 0                       #j = 0
                addi $t1, $t1, 1                #i++
                blt $t1, $a1, LoopLinha         #Se o i for menor que o numero de linhas/colunas salta pro loop novamente
                li $t1, 0       #i = 0 
                lw $ra, ($sp)                   #Recupera o endereco do $ra que estava na pilha
                addi $sp, $sp, 4                #Devolve o ponteiro da pilha pro topo
                move $v0, $a3                   #Salva o endereco base da matriz em v0
                jr $ra

            LoopColuna:
                jal Indice                  #Calcula o v0 de acordo com o indice
                lw $a0, ($v0)               #Carrega em a0 o valor da posicao calculada
                move $t3, $a0               #$t3 recebe o valor da posicao atual da matriz
                addi $t1, $t1, 1            #i++
                
                bne $t3, $zero, Nao_Zero    #o valor atual nao é zero, entao salta pro label que verifica se nao é o numero 1
                addi $s1, $s1, 1            #s1 é incrementado em +1 vamos usar pra verificar se a linha possuin n-1 zeros

                Continua2:
                blt $t1, $a1, LoopColuna        #Se o i é menor q o numero de colunas da matriz
                bne $s1, $t9, Nao_Permutativa   #Se a linha nao possui n-1 elementos igual a 0 a matriz nao é permutativa
                li $s1, 0

                li $t1, 0                       #i = 0
                addi $t2, $t2, 1                #j++
                blt $t2, $a1, LoopColuna        #Se o j for menor que o numero de linhas salta pro loop novamente
                li $t2, 0                       #j = 0 
                lw $ra, ($sp)                   #Recupera o endereco do $ra que estava na pilha
                addi $sp, $sp, 4                #Devolve o ponteiro da pilha pro topo
                move $v0, $a3                   #Salva o endereco base da matriz em v0
                jr $ra

        Nao_Zero:
            bne $t3, 1, Nao_Permutativa             #Se o valor atual nao for igual a 1 a matriz nao é permutativa
            beq $t8, $zero, Continua2               #Se o booleano for 0 salta pro continua2
            j Continua

        Nao_Permutativa:
            li $v0, 4                               #Codigo SysCall para escrever strings
            la $a0, msg_false                       #Armazena em $a0 a mensagem de saida caso a matriz nao seja permutativa
            syscall
            j Finaliza                              #Salta pro label de finalizacao do programa

    Loop_Erro:
        li $v0, 4                                   #Codigo SysCall para escrever strings      
        la $a0, msg_erro                            #Armazena em $a0 o endereco da variavel msg_erro
        syscall                                     #Imprime a mensagem que esta salva em $a0
        j Leitura_N