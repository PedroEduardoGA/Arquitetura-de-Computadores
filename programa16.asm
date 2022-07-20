#Programa lê uma matriz MxN e informa a quantidade de linhas e colunas nulas da mesma
.data
    ent1: .asciiz "Insira o valor da posicao["
    ent2: .asciiz "]["
    ent3: .asciiz "]: "
    msg_entM: .asciiz "Entre com um valor inteiro para a quantidade de linhas desejadas (M>1). "
    msg_entN: .asciiz "Entre com um valor inteiro para a quantidade de colunas desejadas (N>1). "
    msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 1. "
    msg_saida: .asciiz "A matriz possui "
    msg_saida2: .asciiz " linha(s) nulas e "
    msg_saida3: .asciiz " coluna(s) nulas!"

.align 2

.text   
    Leitura_M: 
        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_entM        #Armazena em $a0 o endereco da variavel "msg_entM"
        syscall                 #Imprime a mensagem que esta salva em $a0
        li $v0, 5               #Codigo SysCall para ler inteiros
        syscall                 #Chamada de sistema para leitura de inteiro
        ble $v0, 0, Loop_ErroM   #Se o valor digitado for menor ou igual que 0 salta para o label Loop_Erro

        add $s0, $v0, $zero     #Armazena em $s0 o valor lido de M

    Leitura_N:
        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_entN        #Armazena em $a0 o endereco da variavel "msg_entN"
        syscall                 #Imprime a mensagem que esta salva em $a0
        li $v0, 5               #Codigo SysCall para ler inteiros
        syscall                 #Chamada de sistema para leitura de inteiro
        ble $v0, 0, Loop_ErroN   #Se o valor digitado for menor ou igual que 0 salta para o label Loop_Erro

        add $s1, $v0, $zero     #Armazena em $s1 o valor lido de N

    Alocacao:
        mul $s2, $s0, $s1       #$s1 recebe o valor de NxN
        mul $s2, $s2, 4         #s1 recebe o valor (Nxn) multiplicado por 4(Espaço ocupado por 1 Byte)
        move $a0, $s2           #$a0 recebe o tamanho total do vetor a ser alocado
        li $v0, 9               #Codigo SysCall de alocação dinamica
        syscall                 #Chamada de sistema para alocação
        move $t0, $v0           #Move $v0 para $t0

    Main:
        move $a0, $t0           #a0 recebe o endereco base da matriz alocada
        move $a1, $s0           #a1 recebe (M) o numero de linhas
        move $a2, $s1           #a2 recebe (N) o numero de colunas

        jal Leitura

        move $a0, $v0
        jal Escrita

        li $s0, 0               #s0 vai ser usado para saber a quantidade de linhas nulas
        li $t8, 1               #Booleano para saber se é pra verificar linhas ou colunas comeca com 1 pois vou verificar as linhas primeiro
        move $a0, $v0
        jal Verificacao

        li $s1, 0               #s1 vai ser usado para saber a quantidade de colunas nulas
        li $t8, 0
        move $a0, $v0
        jal Verificacao

        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_saida       #Armazena em $a0 o endereco da variavel "msg_saida"
        syscall
        move $a0, $s0
        li $v0, 1
        syscall

        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_saida2      #Armazena em $a0 o endereco da variavel "msg_saida2"
        syscall
        move $a0, $s1
        li $v0, 1
        syscall

        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_saida3      #Armazena em $a0 o endereco da variavel "msg_saida3"
        syscall

        li $v0,10
        syscall

        Indice:
            mul $v0, $t1, $a2  #i * ncol
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
                blt $t2, $a2, Laco  #Se o j é menor q o numero de colunas da matriz
                li $t2, 0
                addi $t1, $t1, 1    #Incrementa o i
                blt $t1, $a1, Laco  #Se o i é menor q o numero de linhas da matriz
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
                blt $t2, $a2, Laco_Escrita  #Se o j é menor q o numero de colunas da matriz
                la $a0, 10                  #Codigo ascii para o \n
                syscall
                li $t2, 0                   #j = 0
                addi $t1, $t1, 1            #i++
                blt $t1, $a1, Laco_Escrita  #Se o i for menor que o numero de linhas salta pro loop novamente
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
            li $t9, 0                           #t9 inicia com 0 pois sera o somatorio da linha/coluna
            beq $t8, $zero, LoopColuna

            LoopLinha:
                jal Indice                      #Calcula o v0 de acordo com o indice
                lw $a0, ($v0)                   #Carrega em a0 o valor da posicao calculada
                move $t3, $a0
                addi $t2, $t2, 1                #j++
                
                add $t9, $t9, $t3               #t9 recebe o somatorio e o valor atual
                blt $t2, $a2, LoopLinha         #Se o j é menor q o numero de colunas da matriz
                
                bne $t9, $zero, Continua        #Caso t9 nao seja 0 salta pro label continua
                addi $s0, $s0, 1                #Caso a linha seja nula s0 recebe s0+1

                Continua:
                li $t9, 0                       #t9 reinicia com 0 pois sera o somatorio da linha
                li $t2, 0                       #j = 0
                addi $t1, $t1, 1                #i++
                blt $t1, $a1, LoopLinha         #Se o i for menor que o numero de linhas salta pro loop novamente
                li $t1, 0                       #i = 0 
                lw $ra, ($sp)                   #Recupera o endereco do $ra que estava na pilha
                addi $sp, $sp, 4                #Devolve o ponteiro da pilha pro topo
                move $v0, $a3                   #Salva o endereco base da matriz em v0
                jr $ra

            LoopColuna:
                jal Indice                      #Calcula o v0 de acordo com o indice
                lw $a0, ($v0)                   #Carrega em a0 o valor da posicao calculada
                move $t3, $a0                   #$t3 recebe o valor da posicao atual da matriz
                addi $t1, $t1, 1                #i++

                add $t9, $t9, $t3               
                blt $t1, $a1, LoopColuna        #Se o i é menor q o numero de linhas da matriz
                
                bne $t9, $zero, Continua2       #Caso t9 nao seja 0 salta pro label continua2
                addi $s1, $s1, 1                #Caso a coluna seja nula s1 recebe s1+1

                Continua2:
                li $t9, 0                       #t9 reinicia com 0 pois sera o somatorio da coluna
                li $t1, 0                       #i = 0
                addi $t2, $t2, 1                #j++
                blt $t2, $a2, LoopColuna        #Se o j for menor que o numero de colunas salta pro loop novamente
                li $t2, 0                       #j = 0 
                lw $ra, ($sp)                   #Recupera o endereco do $ra que estava na pilha
                addi $sp, $sp, 4                #Devolve o ponteiro da pilha pro topo
                move $v0, $a3                   #Salva o endereco base da matriz em v0
                jr $ra

    Loop_ErroM:
        li $v0, 4                               #Codigo SysCall para escrever strings      
        la $a0, msg_erro                        #Armazena em $a0 o endereco da variavel msg_erro
        syscall                                 #Imprime a mensagem que esta salva em $a0
        j Leitura_M

    Loop_ErroN:
        li $v0, 4                               #Codigo SysCall para escrever strings      
        la $a0, msg_erro                        #Armazena em $a0 o endereco da variavel msg_erro
        syscall                                 #Imprime a mensagem que esta salva em $a0
        j Leitura_N