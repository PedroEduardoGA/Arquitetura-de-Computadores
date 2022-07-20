#Programa lê duas matrizes NxN com N sendo maior que 1 e menor que 7 e mostra:
#Quantidade de elementos iguais nas matrizes e a soma das posições onde ocorre os elementos iguais
.data
    ent1: .asciiz "Insira o valor da posicao["
    ent2: .asciiz "]["
    ent3: .asciiz "]: "
    msg_entN: .asciiz "Entre com um valor inteiro (N > 1) e (N < 7). "
    msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 1 e menor que 7. "
    msg_saida: .asciiz "A quantidade de elementos iguais em ambas matrizes: "
    msg_saida2: .asciiz " e a soma das posi��es: "
    msg_matriz: .asciiz "\n1a Matriz:\n"
    msg_matriz2: .asciiz "\n2a Matriz:\n"

.align 2

.text   
    Leitura_N: 
        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_entN        #Armazena em $a0 o endereco da variavel "msg_entN"
        syscall                 #Imprime a mensagem que esta salva em $a0
        li $v0, 5               #Codigo SysCall para ler inteiros
        syscall                 #Chamada de sistema para leitura de inteiro
        ble $v0, 0, Loop_Erro   #Se o valor digitado for menor ou igual que 0 salta para o label Loop_Erro
        bgt $v0, 6, Loop_Erro

        add $s0, $v0, $zero     #Armazena em $s0 o valor lido

    Alocacao:
        mul $s1, $s0, $s0       #$s1 recebe o valor de NxN
        mul $s1, $s1, 4         #s1 recebe o valor (Nxn) multiplicado por 4(Espaço ocupado por 1 Byte)
        move $a0, $s1           #$a0 recebe o tamanho total do vetor a ser alocado
        li $v0, 9               #Codigo SysCall de alocação dinamica
        syscall                 #Chamada de sistema para alocação
        move $s7, $v0           #Move $v0 para $s7
        
        move $a0, $s1           #$a0 recebe o tamanho total do vetor a ser alocado
        li $v0, 9               #Codigo SysCall de alocação dinamica
        syscall                 #Chamada de sistema para alocação
        move $s6, $v0           #Move $v0 para $s6
        
        #Ambas matrizes alocadas, a primeira esta em s7 e a segunda esta em s6

    Main:
    	la $a0, msg_matriz
        li $v0, 4
        syscall
        move $a0, $s7           #a0 recebe o endereco base da matriz 1 alocada
        move $a1, $s0           #a1 recebe (n) o numero de linhas
        jal Leitura		#leitura 1a matriz
	
	la $a0, msg_matriz2
        li $v0, 4
        syscall
	move $a0, $s6           #a0 recebe o endereco base da matriz 2 alocada
        move $a1, $s0           #a1 recebe (n) o numero de linhas
        jal Leitura		#leitura 2a matriz
        
        la $a0, msg_matriz
        li $v0, 4
        syscall
        move $a0, $s7
        jal Escrita		#1a matriz
        
        la $a0, msg_matriz2
        li $v0, 4
        syscall
        move $a0, $s6
        jal Escrita		#2a matriz
        
        li $s1, 0		#carrega s1 com 0 (qtd de elementos iguais em ambas matrizes)
        li $s2, 0 		#carrega s2 com 0 (soma das posicoes dos elementos iguais)
        jal Verifica
        la $a0, msg_saida
        li $v0, 4
        syscall
        move $a0, $s1
        li $v0, 1
        syscall
        la $a0, msg_saida2
        li $v0, 4
        syscall
        move $a0, $s2
        li $v0, 1
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
                
	Verifica:
            subi $sp, $sp, 4
            sw $ra ($sp)
            
            Laco_Verifica:
            	move $a3, $s7
                jal Indice                  #Calcula o v0 de acordo com o indice
                lw $t9, ($v0)               #Carrega em t9 o valor da posicao calculada da 1a matriz
                
                move $a3, $s6
                jal Indice                  #Calcula o v0 de acordo com o indice
                lw $t8, ($v0)               #Carrega em t9 o valor da posicao calculada da 2a matriz
                
                bne $t9, $t8, continue
                addi $s1, $s1, 1
                add $s2, $s2, $t2	    #soma recebe +j
                add $s2, $s2, $t1           #soma recebe +i
                
                continue:
                	addi $t2, $t2, 1            #j++
                	blt $t2, $a1, Laco_Verifica #Se o j é menor q o numero de linhas/colunas da matriz
               
                	li $t2, 0                   #j = 0
                	addi $t1, $t1, 1            #i++
                	blt $t1, $a1, Laco_Verifica #Se o i for menor que o numero de linhas/colunas salta pro loop novamente
                	li $t1, 0       #i = 0 
                	lw $ra, ($sp)               #Recupera o endereco do $ra que estava na pilha
                	addi $sp, $sp, 4            #Devolve o ponteiro da pilha pro topo
                	jr $ra
                	
    Loop_Erro:
        li $v0, 4                                   #Codigo SysCall para escrever strings      
        la $a0, msg_erro                            #Armazena em $a0 o endereco da variavel msg_erro
        syscall                                     #Imprime a mensagem que esta salva em $a0
        j Leitura_N
