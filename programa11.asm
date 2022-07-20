#Programa le dois vetores de N posições e mostra a subtração dos elementos das posições pares pelos elementos das posições ímpares
.data 
        msg_vetorA: .asciiz "\nVetor A:\n"                                                                                                      #Cria uma variavel  que ira guardar o texto de entrada do vetor A
        msg_vetorB: .asciiz "\nVetor B:\n"                                                                                                      #Cria uma variavel  que ira guardar o texto de entrada do vetor B
        msg_entrada: .asciiz "Entre com o valor da posicao["                                                                                    #Cria uma variavel  que ira guardar o texto de entrada de Vet
        colchete_fecha: .asciiz "]:"                                                                                                            #Cria uma variavel  que ira guardar o caractere ]
        msg_entN: .asciiz "Entre com um valor inteiro(N>1). "                                                                                   #Cria uma variavel  que ira guardar o texto para entrar com valor N
        msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 1. "                                                                  #Cria uma variavel  que ira guardar o texto de erro caso o numero digitado seja 0 ou negativo
        msg_saida: .asciiz "\n\nA soma dos elementos nas posicoes pares do Vetor menos a soma dos elementos nas posicoes impares do vetor B: "  #Cria uma variavel  que ira guardar o texto do layout de saida
.align 2

.text

.main:

    add $s2, $zero, $zero       #Inicializando variavel s2 que vai ser o somatorio das posicoes pares do vetor A
    add $s3, $zero, $zero       #Inicializando variavel s3 que sera o somatorio das posicoes impares do vetor B
    add $t8, $zero, $zero       #Inicializando o registrador temporario $t8 que servira como um boolean de verificacao

    Leitura_N: 
        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, msg_entN        #Armazena em $a0 o endereco da variavel "msg_entN"
        syscall                 #Imprime a mensagem que esta salva em $a0
        li $v0, 5               #Codigo SysCall para ler inteiros
        syscall                 #Chamada de sistema para leitura de inteiro
        ble $v0, 0, Loop_Erro   #Se o valor digitado for menor ou igual que 0 salta para o label Loop_Erro

        add $s0, $v0, $zero     #Armazena em $s0 o valor lido

    Estrutura_Principal:
        la $a0, msg_vetorA      #$a0 recebe o endereco da mensagem de entrada do vetor A
        li $v0, 4               #Codigo SysCall para escrever strings
        syscall                 #Imprime a mensagem que esta salva em $a0
        jal Leitura_Vetor       #Salta pro label que fara a leitura do vetor (A)
        move $a1, $v0           #Coloca o endereco do vetor A retornado da funcao "Leitura_Vetor" em $a1

        li $t8, 1               #Foi realizado a leitura do vetor A, agora o $t8 recebe 1 que serve para dizer que o vetor A ja foi lido
        la $a0, msg_vetorB      #$a0 recebe o endereco da mensagem de entrada do vetor B
        li $v0, 4               #Codigo SysCall para escrever string
        syscall                 #Imprime a mensagem que esta salva em $a0
        jal Leitura_Vetor       #Salta pro label que fara a leitura do vetor (B)
        move $a2, $v0           #Coloca o endereco do vetor B retornado da funcao "Leitura_Vetor" em $a2

        la $a0, msg_vetorA      #$a0 recebe o endereco da mensagem do vetor A
        li $v0, 4               #Codigo SysCall para escrever string
        syscall                 #Imprime a mensagem que esta salva em $a0
        move $a0, $a1           #Move para $a0 o valor de $a1(Endereco do vetor A)
        jal Escrita_Vetor       #Salta para o label de escrita do vetor (Escrita do vetor A)

        la $a0, msg_vetorB      #$a0 recebe o endereco da mensagem do vetor B
        li $v0, 4               #Codigo SysCall para escrever string
        syscall                 #Imprime a mensagem que esta salva em $a0
        move $a0, $a2           #Move para $a0 o valor de $a2(Endereco do vetor B)
        jal Escrita_Vetor       #Salta para o label de escrita do vetor (Escrita do vetor B)

        la $a0, msg_saida       #$a0 recebe o endereco da mensagem de layout de saida
        li $v0, 4               #Codigo SysCall para escrever string
        syscall                 #Imprime a mensagem que esta salva em $a0
        sub $a0, $s2, $s3       #$a0 recebe o valor da subtracao de $s2 - $s3 (Somatorio dos valores em posicoes pares (A) - Somatorio dos valores em posicoes impares (B))
        li $v0, 1               #Codigo syscall para escrita de inteiros
        syscall                 #Chamada de sistema para escrita do inteiro

        li $v0, 10              #Codigo usado para finalizar o programa
        syscall                 #Finaliza o programa

    Leitura_Vetor:
        mul $s1, $s0, 4         #$s1 recebe o valor lido de N por 4(Espaço ocupado por 1 Byte)
        move $a0, $s1           #$a0 recebe o tamanho total do vetor a ser alocado
        li $v0, 9               #Codigo SysCall de alocação dinamica
        syscall                 #Chamada de sistema para alocação
        move $t0, $v0           #Move $v0 para $t0
        move $t1, $t0           #Armazena em $t1 o valor de $t0
        li $t2, 1               #Inicializa $t2 com 0 que sera o contador (i)

        Laco_Leitura:  
            la $a0, msg_entrada             #$a0 recebe o endereco da msg_entrada
            li $v0, 4                       #Codigo SysCall para escrever string
            syscall                         #Imprime a mensagem que esta salva em $a0
            move $a0, $t2                   #$a0 recebe $t2(indice)
            li $v0, 1                       #Codigo syscall para escrita de inteiros
            syscall                         #Chamada de sistema para escrita do inteiro
            la $a0, colchete_fecha          #Armazena em $a0 o caractere ]
            li $v0, 4                       #Codigo SysCall para escrever string
            syscall                         #Imprime a mensagem que esta salva em $a0
            li $v0, 5                       #Codigo SysCall para ler inteiros
            syscall                         #Chamada de sistema para leitura do inteiro

            li $t9, 2                       #Registrador temporario $t9 recebe 2 para verificacao se um valor é par ou não
            div $t2,$t9                     #Divide $t2 por $t9 ( i / 2) para verificação se a posicao em questao é par
            mfhi $t3                        #$t3 recebe o resto da divisão acima

            beq $t8, $zero, VetorA          #Se $t8 for igual a 0, esta realizando a leitura do vetor A entao buscamos posicoes pares
            bne $t3, $zero, SomaImpar       #Senao, estamos lendo o vetor B, entao comparamos o resto da divisao para ver se a posicao é impar

            Armazenamento:
                sw $v0, ($t1)                   #Armazena em $t1 o inteiro lido
                add $t1, $t1, 4                 #$t1 recebe o valor do vetor (i+1)
                addi $t2, $t2, 1                #Incrementa $t2 em i+1
                ble $t2, $s0, Laco_Leitura      #Se o valor de $t2(i) for menor que $s0(N) salta para o label de leitura novamente
                
                move $v0, $t0                   #Move para $v0 o endereco base do vetor
                jr $ra                          #Retorna para o label Estrutura_Principal

    Escrita_Vetor:
        move $t0, $a0               #Armazena em $t0 o valor base do vetor
        move $t4, $t0               #$t4 recebe o valor de $t0
        li $t2, 1                   #Inicializa $t2 com 1 que sera o contador (i)
    
        Laco_Escrita:  
            lw $a0, ($t4)               #Carrega em $a0 o valor da posicao (i) do vetor
            li $v0, 1                   #Codigo syscall para escrita de inteiros        
            syscall                     #Chamada de sistema para escrita do inteiro
            li $a0, 32                  #Codigo SysCall de ASCII para escrever espaco
            li $v0, 11                  #Codigo SysCall para imprimir caracteres
            syscall                     #Chamada de sistema para impressao do espaco
            add $t4, $t4, 4             #$t1 recebe a posicao (i+1) do vetor
            addi $t2, $t2, 1            #Incrementa o $t2 (i) do vetor em +1
            ble $t2, $s0, Laco_Escrita  #Se $t2(i) for menor que $s0(N), vai para o laco de escrita novamente
            move $v0, $t0               #Move para $a0 o endereco base do vetor
            jr $ra                      #Retorna para a linha em que foi chamado o label

    Loop_Erro:
        li $v0, 4                   #Codigo SysCall para escrever strings      
        la $a0, msg_erro            #Armazena em $a0 o endereco da variavel msg_erro
        syscall                     #Imprime a mensagem que esta salva em $a0
        jr $ra                      #Retorna para a linha em que foi chamado

    VetorA:
        beq $t3, $zero, SomaPar     #Se o $t3(resto da divisão) for igual a 0 a posicao é par entao salto para o label de soma
        j Armazenamento             #Senao salto direto para o label de armazenamento

        SomaPar:
            add $s2, $s2, $v0           #Soma em $s2 o valor da posicao par atual
            j Armazenamento             #Salta para o label de armazenamento
    
    SomaImpar:
        add $s3, $s3, $v0           #Soma em $s3 o valor da posicao impar atual
        j Armazenamento             #Salta para o label de armazenamento