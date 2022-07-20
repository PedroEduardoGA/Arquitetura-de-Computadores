#Programa le um vetor de N posições e o compacta removendo elementos que sejam iguais a 0
.data 
        msg_entrada: .asciiz "Entre com o valor da posicao["                    #Cria uma variavel  que ira guardar o texto de entrada de Vet
        colchete_fecha: .asciiz "]:"                                            #Cria uma variavel  que ira guardar o caractere ]
        msg_entN: .asciiz "Entre com um valor inteiro(N>1). "                   #Cria uma variavel  que ira guardar o texto para entrar com valor N
        msg_saida: .asciiz "\nVetor Compactado:\n"                              #Cria uma variavel  que ira guardar a mensagem do layout de saida
        msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 1. "  #Cria uma variavel  que ira guardar o texto de erro caso o numero digitado seja 0 ou negativo
.align 2

.text

.main:
    Leitura_N: 
        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_entN        #Armazena em $a0 o endereco da variavel "msg_entN"
        syscall                 #Imprime a mensagem que esta salva em $a0
        li $v0, 5               #Codigo SysCall para ler inteiros
        syscall                 #Chamada de sistema para leitura de inteiro
        ble $v0, 0, Loop_Erro   #Se o valor digitado for menor ou igual que 0 salta para o label Loop_Erro

        add $s0, $v0, $zero     #Armazena em $s0 o valor lido

    Estrutura_Principal:
        jal Leitura_Vetor       #Salta para o label de leitura do vetor
        move $a0, $v0           #Coloca o endereco do vetor retornado da funcao "Leitura_Vetor" em $a0
        jal Compactacao         #Salta para o label "Compactacao"
        move $a0, $v0           #Coloca o endereco do vetor retornado da funcao "Compactacao" em $a0
        jal Escrita_Vetor       #Salta para o label de Escrita_Vetor do vetor
        li $v0, 10              #Codigo usado para finalizar o programa
        syscall                 #Finaliza o programa

    Leitura_Vetor:
        mul $s1, $s0, 4         #$s1 recebe o valor lido de N por 4(Espaço ocupado por 1 Byte)
        move $a0, $s1           #$a0 recebe o tamanho total do vetor a ser alocado
        li $v0, 9               #Codigo SysCall de alocação dinamica
        syscall                 #Chamada de sistema para alocação
        move $t0, $v0           #Move $v0 para $t0
        move $t1, $t0           #Armazena em $t1 o valor de $t0
        li $t2, 0               #Inicializa $t2 com 0 que sera o contador (i)
        
        Laco_Leitura:  
            la $a0, msg_entrada             #$a0 recebe o endereco da msg_entrada
            li $v0, 4                       #Codigo SysCall para escrever strings
            syscall                         #Imprime a mensagem que esta salva em $a0
            move $a0, $t2                   #$a0 recebe $t2(indice)
            li $v0, 1                       #Codigo syscall para escrita de inteiros
            syscall                         #Chamada de sistema para escrita do inteiro
            la $a0, colchete_fecha          #Armazena em $a0 o caractere ]
            li $v0, 4                       #Codigo SysCall para escrever strings
            syscall                         #Imprime a mensagem que esta salva em $a0
            li $v0, 5                       #Codigo SysCall para ler inteiros
            syscall                         #Chamada de sistema para leitura do inteiro

            Armazenamento:
                sw $v0, ($t1)                   #Armazena em $t1 o inteiro lido
                add $t1, $t1, 4                 #$t1 recebe o valor do vetor (i+1)
                addi $t2, $t2, 1                #Incrementa $t2 em i+1
                blt $t2, $s0, Laco_Leitura      #Se o valor de $t2(i) for menor que $s0(N) salta para o label de leitura novamente
                move $v0, $t0                   #Move para $v0 o endereco base do vetor
                jr $ra                          #Retorna para o label Estrutura_Principal

    Compactacao:
        move $t0, $a0               #Armazena em $t0 o valor base do vetor
        move $t1, $t0               #$t1 recebe o valor de $t0
        beq $s0, 1, Recupera        #Se o vetor tem tamanho de 1 não é necessario compactar
        li $s1, 0                   #Inicializando o registrador(variavel) s1 com 0
        li $s4, 0                   #Inicializando o registrador(variavel) s4 com 0
        
        Reduz_Vetor:
            lw $s4, ($t1)           #$s4 recebe o valor da posicao atual(i)
            bne	$s4, 0, Continua    #Se o valor nao é igual a 0 continua o processo de procura
            li $s2, 0               #Inicializando o registrador(variavel) s2(j) com 0
            addi $s2, $s1, 1        #Incrementa $s2 (j = i + 1) 
            move $t2, $t1           #$t2 recebe o valor de $t1 
            add $t2, $t2, 4         #$t2 recebe a posicao (i+1) do vetor

            Busca:
                lw $s4, ($t2)           #Armazena em $s4 o valor do vetor na posicao (j)
                beq	$s4, 0, Busca_Prox  #Se $s4 for igual a 0 vai pra proxima busca de elemento diferente de 0
                lw $s3, ($t2)           #$s3 recebe o valor do vetor na posicao (j)
                sw $s3, ($t1)		    #$t1 recebe o valor de $s3 
                li $s4, 0               #Inicializando o registrador(variavel) s4 com 0
                sw $s4, ($t2)           #Armazena o 0 na posicao (j)
                j Continua              #Salta para o label Continua

            Busca_Prox:
                add $t2, $t2, 4         #$t2 recebe a posicao (j+1) do vetor
                addi $s2, $s2, 1        #Incrementa $s2 (j + 1)
                blt	$s2, $s0, Busca	    #Se $s2(j) for menor que o tamanho total do vetor continua a busca
                j Recupera              #Salta para o label Recupera  
    Continua:
        add $t1, $t1, 4               #$t1 recebe o valor do vetor (i+1)
        addi $s1, $s1, 1              #Incrementa $s1 em i+1
        blt	$s1, $s0, Reduz_Vetor	  #Se $s1(i) for menor que o tamanho total do vetor continua a busca por elementos 0

    Recupera:
        move $v0, $t0                 #Armazena em $t0 o valor base do vetor
        jr $ra                        #Retorna para a linha em que foi chamado


    Escrita_Vetor:
        move $t0, $a0               #Armazena em $t0 o valor base do vetor
        move $t1, $t0               #$t1 recebe o valor de $t0
        li $t2, 0                   #Inicializa $t2 com 0 que sera o contador (i)
        la $a0, msg_saida           #$a0 recebe a mensagem do layout de saida
        li $v0, 4                   #Codigo SysCall para escrever strings
        syscall                     #Imprime a mensagem que esta salva em $a0
    Laco_Escrita:
        lw $a0, ($t1)               #Carrega em $a0 o valor da posicao (i) do vetor
        li $v0, 1                   #Codigo syscall para escrita de inteiros        
        syscall                     #Chamada de sistema para escrita do inteiro
        li $a0, 32                  #Codigo SysCall de ASCII para escrever espaco
        li $v0, 11                  #Codigo SysCall para imprimir caracteres
        syscall                     #Chamada de sistema para impressao do espaco
        add $t1, $t1, 4             #$t1 recebe a posicao (i+1) do vetor
        addi $t2, $t2, 1            #Incrementa o $t2 (i) do vetor em +1
        blt $t2, $s0, Laco_Escrita  #Se $t2(i) for menor que $s0(N), vai para o laco de escrita novamente
        move $v0, $t0               #Armazena em $t0 o valor base do vetor
        jr $ra                      #Retorna para a linha em que foi chamado

    Loop_Erro:
        li $v0, 4                   #Codigo SysCall para escrever strings      
        la $a0, msg_erro            #Armazena em $a0 o endereco da variavel msg_erro
        syscall                     #Imprime a mensagem que esta salva em $a0
        jr $ra                      #Retorna para a linha em que foi chamado