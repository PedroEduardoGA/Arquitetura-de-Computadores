#Programa lê uma matriz NxN com N sendo maior que 1 e menor que 8 e mostra:
#Subtração dos elementos acima da diag. principal pelos elementos abaixo da diag. principal, o maior elemento acima da diag. principal,
#o menor elemento abaixo da diag. principal e a matriz ordenada na ordem crescente
.data
    ent1: .asciiz "Insira o valor da posicao["
    ent2: .asciiz "]["
    ent3: .asciiz "]: "
    msg_entN: .asciiz "Entre com um valor inteiro (N > 1) e (N < 8). "
    msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 1 e menor que 8. "
    msg_saida: .asciiz "A subtracao dos elementos acima da diagonal pelos de baixo da diagonal: "
    msg_saida2: .asciiz "\n O maior elemento acima da diagonal: "
    msg_saida3: .asciiz "\n O menor elemento abaixo da diagonal: "
    msg_saida4: .asciiz "\nMatriz ordenada:\n"

.align 2

.text   
    Leitura_N: 
        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_entN        #Armazena em $a0 o endereco da variavel "msg_entN"
        syscall                 #Imprime a mensagem que esta salva em $a0
        li $v0, 5               #Codigo SysCall para ler inteiros
        syscall                 #Chamada de sistema para leitura de inteiro
        ble $v0, 0, Loop_Erro   #Se o valor digitado for menor ou igual que 0 salta para o label Loop_Erro
        bgt $v0, 8, Loop_Erro

        add $s0, $v0, $zero     #Armazena em $s0 o valor lido

    Alocacao:
        mul $s1, $s0, $s0       #$s1 recebe o valor de NxN
        mul $s1, $s1, 4         #s1 recebe o valor (Nxn) multiplicado por 4(Espaço ocupado por 1 Byte)
        move $a0, $s1           #$a0 recebe o tamanho total do vetor a ser alocado
        li $v0, 9               #Codigo SysCall de alocação dinamica
        syscall                 #Chamada de sistema para alocação
        move $s7, $v0           #Move $v0 para $s7
        #Ambas matriz alocada, endereco esta em s7

    Main:
        move $a0, $s7           #a0 recebe o endereco base da matriz alocada
        move $a1, $s0           #a1 recebe (n) o numero de linhas
        jal Leitura		#leitura matriz

        move $a0, $s7
        jal Escrita              
        
        li $s1, 0		#carrega s1 com 0 (soma elementos acima da diagonal principal)
        li $s2, 0 		#carrega s2 com 0 (soma elementos abaixo da diagonal principal)
        li $s3, 0		#carrega s3 com 0 (maior elemento acima da diagonal principal)
        li $s4, 999 		#carrega s4 com 999 (menor elemento abaixo da diagonal principal)
        jal Verifica
        la $a0, msg_saida
        li $v0, 4
        syscall
        sub $a0, $s1, $s2      #a0 recebe a subtracao
        li $v0, 1
        syscall
        
        la $a0, msg_saida2
        li $v0, 4
        syscall
        move $a0, $s3
        li $v0, 1
        syscall
        
        la $a0, msg_saida3
        li $v0, 4
        syscall
        move $a0, $s4
        li $v0, 1
        syscall
        
        li $v0, 11		#codigo imprimir caractere
        la $a0, 10              #Codigo ascii para o \n
        syscall
                
        move $a3, $s7           #a3 recebe o endereco base da matriz alocada
        jal Ordenacao_Vetor
        
        la $a0, msg_saida4
        li $v0, 4
        syscall
        move $a0, $s7
	jal Escrita		#escrita matriz ordenada
	
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
                jr $ra

        Escrita:
            subi $sp, $sp, 4
            sw $ra ($sp)
            move $a3, $a0
            li $t1, 0
            li $t2, 0
            
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
                jr $ra
                
	Verifica:
            subi $sp, $sp, 4
            sw $ra ($sp)
            
            Laco_Verifica:
                jal Indice                  #Calcula o v0 de acordo com o indice
                lw $t9, ($v0)               #Carrega em t9 o valor da posicao calculada da 1a matriz
                
                bgt $t2, $t1, acima	    #se j > i esta acima da diagonal principal
                blt $t2, $t1, abaixo        #se j < i esta abaixo da diagonal principal
                
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
		
		acima:
			add $s1, $s1, $t9
			ble $t9, $s3, continue     #se o valor da posicao atual for menor que s3 salta pra continue
			add $s3, $zero, $t9        #senao armazena o valor em s3
			j continue
			
		abaixo:
			add $s2, $s2, $t9
			bge $t9, $s4, continue     #se o valor da posicao atual for maior que s4 salta pra continue
			add $s4, $zero, $t9        #senao armazena o valor em s4
			j continue
	
	Ordenacao_Vetor:
		move $t8, $a3			    #t8 possui o endereco base do vetor
        	move $t9, $a3                       #t9 possui o endereco do vetor, a3 contem o endereco do vetor base e a1 contem o tamanho do vetor
        	
        	mul $t7, $s0, $s0	            #a1 recebe nxn
        	subi $t3, $t7, 1                    #Subtrai 1 do valor de $a1(indice j)
       	 	Laco1:                              	#Funciona como um for(j = N-1 ; j>=1 ; j--)
            		li $t2, 0                       #Carrega 0 em $t2(i)
            		beq $t2, $t3, Resultado		#Se $t2 for igual a $t3(i == j) entao vai para a funcao Resultado
            		move $t1, $t8                   #Armazena em $t1 o valor de $t8, t1 sera a posicao i do vetor
            		addi $t9, $t1, 4                 #$t9 recebe o endereco de vet[i+1]
            		Laco2:                          #Funciona como: for(i = 0 ; i<j ; i++)
                		lw $s1, ($t1)               #$s1 recebe o valor armazenado no endereco $t1(elemento i do vetor)
                		lw $s2, ($t9)               #$s2 recebe o valor armazenado no endereco $t4(elemento i+1 do vetor)
               			ble $s1, $s2, Continue	    #Se o elemento da posicao i for menor que da posicao i+1 avanca para o proximo laco                 
                		sw $s2, ($t1)               #Caso seja maior troca de posicao deixando na posicao i o elemento que estava em i+1
                		sw $s1, ($t9)               #Caso seja maior troca de posicao deixando na posicao i+1 o elemento que estava em i
           
                Continue:
                    addi $t1, $t1, 4         #Incrementa em $t1 o valor da proxima posicao do vetor
                    addi $t9, $t9, 4         #Incrementa em $t4 o valor da proxima posicao do vetor
                    addi $t2, $t2, 1        #Incrementa o indice $t2(i) em +1
                    blt	$t2, $t3, Laco2	    #Se $t2 for menor que $t3(i < j) entao vai para o label Laco2
                    
            subi $t3, $t3, 1                #Subtrai 1 do valor de $t3(indice j)
            bge $t3, 1, Laco1               #Se $t3 for maior ou igual a 1( j >= 1) vai para o label Laco1
        
        Resultado:
            move $v0, $a3                   #$v0 recebe o endereco do vetor
            jr $ra
            
    Loop_Erro:
        li $v0, 4                                   #Codigo SysCall para escrever strings      
        la $a0, msg_erro                            #Armazena em $a0 o endereco da variavel msg_erro
        syscall                                     #Imprime a mensagem que esta salva em $a0
        j Leitura_N
