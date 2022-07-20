#Programa le um vetor de N e um valor K, e mostra os valores que são maiores que K e menores que 2K
.data 
        entrada: .asciiz "Entre com o valor da posicao["                                                 #Cria uma variavel  que ira guardar o texto de entrada de Vet
        fim_vet: .asciiz "]:"                                                                            #Cria uma variavel  que ira guardar o caractere ]
        ent_K: .asciiz "Entre com o valor K inteiro (k > 0). "                                           #Cria uma variavel  que ira guardar o texto de entrada K
        ent_N: .asciiz "Entre com um valor inteiro(N > 0). "                                             #Cria uma variavel  que ira guardar o texto para entrar com valor N
        msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 0.\n "                         #Cria uma variavel  que ira guardar o texto de erro caso o numero digitado seja 0 ou negativo
        saida: .asciiz "\nA quantidade de elementos cujo valor atende ao critério (K > valor < 2*K): "   #Cria uma variavel  que ira guardar a mensagem do layout de saida
.align 2
vet: .space 150

.text

.main: 

    add $s0, $zero, $zero       #Inicializando variavel s0 (N) que define o tamanho do vetor
    add $s1, $zero, $zero       #Inicializando variavel s1 (K) que define a chave

    Leitura_N: 
        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, ent_N           #Armazena em $a0 o endereco da variavel ent_N
        syscall                 #Imprime a string salva em $a0
        li $v0, 5               #Codigo SysCall para ler inteiros
        syscall                 #Chamada de sistema para leitura de inteiro
        ble $v0, 0, Erro        #Se o valor digitado for menor ou igual que 0 salta para o label Erro

        add $s0, $v0, $zero     #Armazena em $s0 o valor lido

    Leitura_K:
        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, ent_K           #Armazena em $a0 o endereco da variavel ent_K
        syscall                 #Imprime a string salva em $a0
        li $v0, 5               #Codigo SysCall para ler inteiros
        syscall                 #Chamada de sistema para leitura de inteiro
        blt $v0, 0, Erro        #Se o valor digitado for menor ou igual que 0 salta para o label Erro

        add $s1, $v0, $zero     #Armazena o valor lido de "k" em s1
        li $t3, 0               #Inicializa t3 com 0 que vai ser usado para calcular quantos elementos entram no critério
        li $t0, 2               #Armazena em $t0 o valor 2 temporariamente
        mul $t4, $s1, $t0       #Armazena em $t4 o resultado da multiplicacao s1*t0 (K*2)

    Estrutura_Main:
        la $a0, vet             #Armazena em $a0 o endereco do vetor
        jal Leitura_Vetor       #Salta para o label de leitura do vetor
        move $a0, $v0           #Coloca o endereco do vetor retornado da funcao "leitura" em $a0
        jal Escrita             #Salta para o label de escrita do vetor

        li $v0, 10              #Codigo usado para finalizar o programa
        syscall                 #Finaliza o programa

    Leitura_Vetor:
        move $t0, $a0           #Move para $t0 o endereco base do vetor
        move $t1, $t0           #Armazena em $t1 o valor de $t0
        li $t2, 0               #Inicializa $t2 com 0 que sera o contador (i)

        Laco_Leitura:  
            la $a0, entrada             #Carrega em $a0 o endereco da variavel "entrada"
            li $v0, 4                   #Codigo SysCall para escrever strings
            syscall                     #Imprime a string salva em $a0
            move $a0, $t2               #Move para $a0 o valor do $t2(i)
            li $v0, 1                   #Codigo SysCall para escrever inteiros
            syscall                     #Chamada de sistema para escrita do inteiro
            la $a0, fim_vet             #Armazena em $a0 o caractere ]
            li $v0, 4                   #Codigo SysCall para escrever strings
            syscall                     #Imprime a string salva em $a0

            li $v0, 5                   #Codigo SysCall para ler inteiros
            syscall                     #Chamada de sistema para leitura do inteiro
            bgt $v0, $s1, Verifica      #Se o valor digitado é maior que k então é redirecionado pro label verifica

        Armazenamento:
            sw $v0, ($t1)               #Armazena em $v0 o inteiro lido
            add $t1, $t1, 4             #$t1 recebe o valor do vetor (i+1)
            addi $t2, $t2, 1            #Incrementa $t2 em i+1
            blt $t2, $s0, Laco_Leitura  #Se o valor de $t2(i) for menor que $s0(N) salta para o label de leitura novamente
            move $v0, $t0               #Move para $v0 o endereco base do vetor
            jr $ra                      #Retorna pro label Estrutura_Principal

    Escrita:
        move $t0, $a0        #Armazena em $t0 o valor base do vetor
        move $t1, $t0        #$t1 recebe o valor de $t0
        li $t2, 0            #Inicializa $t2 com 0 que sera o contador (i)
        
        Laco_Escrita:  
            lw $a0, ($t1)               #Carrega em $a0 o valor da posicao (i) do vetor
            li $v0, 1                   #Codigo SysCall para escrever inteiros        
            syscall                     #Chamada de sistema para escrita do inteiro
            li $a0, 32                  #Codigo ASCII para escrever espaco
            li $v0, 11                  #Codigo para imprimir caracteres
            syscall                     #Imprime o espaco
            add $t1, $t1, 4             #$t1 recebe a posicao (i+1) do vetor
            addi $t2, $t2, 1            #Incrementa $t2 em i+1
            blt $t2, $s0, Laco_Escrita  #Se o valor de $t2(i) for menor que $s0(N) salta para o label de Laco_escrita novamente

            la $a0, saida               #$a0 recebe a mensagem do layout de saida
            li $v0, 4                   #Imprime a string salva em $a0
            syscall                     #Chamada de sistema para escrita de string 
            move $a0, $t3               #Atribui pra $a0 o valor de $t3
            li $v0, 1                   #Codigo para escrever inteiros        
            syscall                     #Chamada de sistema para escrita do inteiro

            move $v0, $t0               #Move para $v0 o endereco base do vetor
            jr $ra                      #Retorna pro label Estrutura_Principal

    Verifica:
        blt $v0, $t4, Incremento        #Valor digitado eh menor que 2*k entao salta pro label incremento
        j Armazenamento                 #Independente do resultado logico acima, salta pro label de armazenamento do valor lido

    Incremento:
        addi $t3, $t3, 1                #Incrementa o valor de $t3 em +1, pois o valor lido foi maior que K e menor que 2*k
        j Armazenamento                 #Independente do resultado logico acima, salta pro label de armazenamento do valor lido

    Erro:
        li $v0, 4                       #Codigo para escrever strings      
        la $a0, msg_erro                #Armazena em $a0 o endereco da variavel msg_erro
        syscall                         #Imprime a string salva em $a0
        beq $s0, $zero, Leitura_N       #Se o valor de $s0 for igual a 0 entao o valor de N ainda nao foi lido, entao salta para o labal de Leitura_N
        beq $s1, $zero, Leitura_K       #Se o valor de $s1 for igual a 0 entao o valor de K ainda nao foi lido, entao salta para o labal de Leitura_K

    


                     
