#Programa le um vetor de N posições e apresenta como saída: maior elemento, menor elementoe suas respectivas posições
.data 
        msg_entrada: .asciiz "Entre com o valor da posicao["                    #Cria uma variavel que ira guardar o texto de entrada de Vet
        colchete_fecha: .asciiz "]:"                                            #Cria uma variavel que ira guardar o caractere ]
        msg_entN: .asciiz "Entre com um valor inteiro(N>1). "                   #Cria uma variavel que ira guardar o texto para entrar com valor N
        msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 1. "  #Cria uma variavel que ira guardar o texto de erro caso o numero digitado seja 0 ou negativo
        msg_maior: .asciiz "\nO maior elemento do vetor: "                      #Cria uma variavel que ira guardar o texto de saida apresentando o maior elemento
        msg_menor: .asciiz "\nO menor elemento do vetor: "                      #Cria uma variavel que ira guardar o texto de saida apresentando o menor elemento
        msg_posicao: .asciiz " e sua respectiva posicao: "                      #Cria uma variavel que ira guardar o texto que se refere a posicao do elemento
.align 2

.text

.main:

    add $s2, $zero, $zero       #Inicializando variavel s1 que vai ser o maior valor
    add $s3, $zero, $zero       #Inicializando variavel s2 que sera o menor valor
    add $t9, $zero, $zero       #Inicializando $t9 com 0 que sera um booleano de controle

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
            la $a0, msg_entrada                 #$a0 recebe o endereco da msg_entrada
            li $v0, 4                           #Codigo SysCall para escrever strings
            syscall                             #Imprime a mensagem que esta salva em $a0
            move $a0, $t2                       #$a0 recebe $t2(indice)
            li $v0, 1                           #Codigo syscall para escrita de inteiros
            syscall                             #Chamada de sistema para escrita do inteiro
            la $a0, colchete_fecha              #Armazena em $a0 o caractere ]
            li $v0, 4                           #Codigo SysCall para escrever strings
            syscall                             #Imprime a mensagem que esta salva em $a0
            li $v0, 5                           #Codigo SysCall para ler inteiros
            syscall                             #Chamada de sistema para leitura do inteiro
            beq $t9, 0, Primeiro_Armazenamento  #Se o booleano de controle $t9 for 0 salta para o label primeiro armazenamento
            bgt $v0, $s2, Valor_maior           #Se o valor lido for maior que $s2 salta pro label Valor maior
            
            Verifica_Menor:
                blt $v0, $s3, Valor_menor       #Se o valor lido for maior que $s2 salta pro label Valor menor

            Armazenamento:
                sw $v0, ($t1)                   #Armazena em $t1 o inteiro lido
                add $t1, $t1, 4                 #$t1 recebe o valor do vetor (i+1)
                addi $t2, $t2, 1                #Incrementa $t2 em i+1
                blt $t2, $s0, Laco_Leitura      #Se o valor de $t2(i) for menor que $s0(N) salta para o label de leitura novamente
                move $v0, $t0                   #Move para $v0 o endereco base do vetor
                jr $ra                          #Retorna para o label Estrutura_Principal

    Recupera:
        move $v0, $t0                 #Armazena em $t0 o valor base do vetor
        jr $ra                        #Retorna para a linha em que foi chamado


    Escrita_Vetor:
        move $t0, $a0               #Armazena em $t0 o valor base do vetor
        move $t1, $t0               #$t1 recebe o valor de $t0
        li $t2, 0                   #Inicializa $t2 com 0 que sera o contador (i)
        
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

            la $a0, msg_maior           #$a0 recebe a mensagem do layout de saida que apresenta o maior valor
            li $v0, 4                   #Codigo SysCall para escrever strings
            syscall                     #Chamada de sistema para imprimir $a0
            move $a0, $s2               #$a0 recebe $s2(maior valor)
            li $v0, 1                   #Codigo syscall para escrita de inteiros
            syscall                     #Chamada de sistema para imprimir $a0
            la $a0, msg_posicao         #$a0 recebe a mensagem de posicao
            li $v0, 4                   #Codigo SysCall para escrever strings
            syscall                     #Chamada de sistema para imprimir $a0
            move $a0, $t8               #$a0 recebe $t8(indice maior valor)
            li $v0, 1                   #Codigo syscall para escrita de inteiros
            syscall                     #Chamada de sistema para imprimir $a0

            la $a0, msg_menor           #$a0 recebe a mensagem do layout de saida que apresenta o menor valor
            li $v0, 4                   #Codigo SysCall para escrever strings
            syscall                     #Chamada de sistema para imprimir $a0
            move $a0, $s3               #$a0 recebe $s3(menor valor)
            li $v0, 1                   #Codigo syscall para escrita de inteiros
            syscall                     #Chamada de sistema para imprimir $a0
            la $a0, msg_posicao         #$a0 recebe a mensagem de posicao
            li $v0, 4                   #Codigo SysCall para escrever strings
            syscall                     #Chamada de sistema para imprimir $a0
            move $a0, $t7               #$a0 recebe $t7(indice menor valor)
            li $v0, 1                   #Codigo syscall para escrita de inteiros
            syscall                     #Chamada de sistema para imprimir o inteiro

            move $v0, $t0               #Armazena em $t0 o valor base do vetor
            jr $ra                      #Retorna para a linha em que foi chamado

    Loop_Erro:
        li $v0, 4                   #Codigo SysCall para escrever strings      
        la $a0, msg_erro            #Armazena em $a0 o endereco da variavel msg_erro
        syscall                     #Imprime a mensagem que esta salva em $a0
        jr $ra                      #Retorna para a linha em que foi chamado

    Primeiro_Armazenamento:
        add $s2, $v0, $zero         #$s2 recebe o primeiro valor lido que servirá como base para definir o maior valor de fato
        add $s3, $v0, $zero         #$s3 recebe o primeiro valor lido que servirá como base para definir o menor valor de fato
        li $t8, 1                   #$t8 recebe 1 pois é a posicao do maior valor
        li $t7, 1                   #$t8 recebe 1 pois é a posica do menor valor até o momento
        li $t9, 1                   #O booleano de controle $t9 recebe 1, agora nao sera mais realizado esse primeiro_armazenamento
        j Armazenamento             #Salta para o label armazenamento 

    Valor_maior:
        add $s2, $v0, $zero         #$s2 recebe o valor lido que é maior que o valor anterior armazenado em $s2
        addi $t8, $t2, 1            #$t8 recebe a posicao do valor atual
        j Verifica_Menor            #Salta para o label Verifica_menor

    Valor_menor:
        add $s3, $v0, $zero         #$s3 recebe o valor lido que é menor que o valor anterior armazenado em $s3
        addi $t7, $t2, 1            #$t8 recebe a posicao do valor atual
        j Armazenamento             #Salta para o label Verifica_menor