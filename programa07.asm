#Programa le um vetor de N posições e o ordena de forma crescente
.data 
        msg_entrada: .asciiz "Entre com o valor da posicao["                     #cria o texto de entrada
        fim_vet: .asciiz "]:"                                                    #cria o texto de fechamento dos []
        msg_valorN: .asciiz "Entre com um valor inteiro(N>1). "                  #cria o texto de entrada do valor N
        msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 1.\n"  #cria o texto de erro caso o numero digitado seja negativo ou 0
.align 2
vet: .space 150

.text

.main: 
    Leitura_N: 
        li $v0, 4               #Chamada de sistema para escrever strings
        la $a0, msg_valorN      #Passando a mensagem da variavel "msg_valorN" para o registrador de argumento $a0
        syscall                 #Vai imprimir $a0 na tela
        li $v0, 5               #Usando o codigo chamada de sistema para ler inteiros
        syscall                 #O inteiro de entrada "N" foi lido e esta em $v0
        ble $v0, 0, Erro        #Caso o valor digitado de $v0 for menor ou igual ao inteiro "0", vai para Erro
        add $s0, $v0, $zero     #Guarda em $s0 o número digitado "N" que esta em $v0

    Estrutura_Principal:
        la $a0, vet             #Endereco do vetor
        jal Leitura_Elementos   #Salta para o label de Leitura_Elementos dos valores do vetor

        move $a0, $v0           #Coloca o endereco do vetor retornado da funcao "Leitura_Elementos" em $a0
        jal Ordenacao_Vetor     #Salta para o label que ordena o vetor em ordem crescente
        move $a0, $v0           #Coloca o endereco do vetor retornado da funcao "ordena" em $a0
        jal Escrita_Vetor       #Salta para o label Escrita_Vetor que imprime o vetor na tela

        li $v0, 10              #Codigo usado para finalizar o programa
        syscall                 #Finaliza o programa

    Leitura_Elementos:
        move $t0, $a0           #Armazena o endereco do vetor
        move $t1, $t0           #Armazena o endereco de $t0 em $t1
        li $t2, 0               #Inicia o indice i do vetor com 0
        
        Laco_Leitura:  
            la $a0, msg_entrada             #Carrega a string entrada
            li $v0, 4                       #Codigo de chamada de sistema para escrever strings
            syscall                         #Escrevendo a string
        
            move $a0, $t2                   #Carrega o indice i do vetor
            li $v0, 1                       #Usando o codigo de chamada de sistema para escrever inteiros
            syscall                         #Escrevendo o inteiro
        
            la $a0, fim_vet                 #Carrega a string fim_vet
            li $v0, 4                       #Chamada de sistema para escrever strings
            syscall                         #Escrevendo a string
            li $v0, 5                       #Chamada de sistema para ler inteiros
            syscall                         #Lendo o inteiro
            sw $v0, ($t1)                   #Armazena o inteiro lido em vet[i]
            add $t1, $t1, 4                 #O registrador temporario $t1 recebe o endereco de vet[i+1]
            addi $t2, $t2, 1                #Incrementa o indice i do vetor em 1
            blt $t2, $s0, Laco_Leitura      #Se $t2(i) for menor que $s0(N) executa mais uma leitura de elemento
            move $v0, $t0                   #Aramzena o endereco de $t0(vetor) em $v0 para retorno da funcao
            jr $ra                          #Retorna para a funcao main Estrutura_Principal

    Ordenacao_Vetor:
        move $t0, $a0                       #Armazena o endereco de $a0 em $t0
        add $t3, $s0, 0                     #Armazena em $t3 o tamanho do vetor(N)
        subi $t3, $t3, 1                    #Subtrai 1 do valor de $t3(indice j)
        Laco1:                              #Funciona como um for(j = N-1 ; j>=1 ; j--)
            li $t2, 0                       #Carrega 0 em $t2(i)
            beq	$t2, $t3, Resultado	        #Se $t2 for igual a $t3(i == j) entao vai para a funcao Resultado
            move $t1, $t0                   #Armazena em $t1 o valor de $t0
            move $t4, $t0                   #Armazena em $t4 o valor de $t0
            add $t4, $t4, 4                 #$t4 recebe o endereco de vet[i+1]
            Laco2:                          #Funciona como: for(i = 0 ; i<j ; i++)
                lw $s1, ($t1)               #$s1 recebe o valor armazenado no endereco $t1(elemento i do vetor)
                lw $s2, ($t4)               #$s2 recebe o valor armazenado no endereco $t4(elemento i+1 do vetor)
                ble	$s1, $s2, Continue	    #Se o elemento da posicao i for menor que da posicao i+1 avanca para o proximo laco                 
                sw $s2, ($t1)               #Caso seja maior troca de posicao deixando na posicao i o elemento que estava em i+1
                sw $s1, ($t4)               #Caso seja maior troca de posicao deixando na posicao i+1 o elemento que estava em i
           
                Continue:
                    add $t1, $t1, 4         #Incrementa em $t1 o valor da proxima posicao do vetor
                    add $t4, $t4, 4         #Incrementa em $t4 o valor da proxima posicao do vetor
                    addi $t2, $t2, 1        #Incrementa o indice $t2(i) em +1
                    blt	$t2, $t3, Laco2	    #Se $t2 for menor que $t3(i < j) entao vai para o label Laco2
                    
            subi $t3, $t3, 1                #Subtrai 1 do valor de $t3(indice j)
            bge $t3, 1, Laco1               #Se $t3 for maior ou igual a 1( j >= 1) vai para o label Laco1
        
        Resultado:
            move $v0, $t0                   #$v0 recebe o endereco do vetor
            jr $ra                          #Volta para o label Estrutura_Principal


    Escrita_Vetor:
        move $t0, $a0        #$t0 recebe o endereco do vetor
        move $t1, $t0        #$t1 recebe o endereco de $t0
        li $t2, 0            #Incializa $t2(i) com 0
        
        Laco_Escrita:  
            lw $a0, ($t1)                   #Carrega em $a0 o valor da posicao i
            li $v0, 1                       #Chamada de sistema para escrever inteiros        
            syscall                         #Escrita do inteiro
            li $a0, 32                      #Chamada de sistema para escrever espaco
            li $v0, 11                      #Chamada de sistema para imprimir caracteres
            syscall                         #Escrita do espaco
            add $t1, $t1, 4                 #Incrementa em $t1 o valor da proxima posicao do vetor
            addi $t2, $t2, 1                #Incrementa o indice $t2(i) em +1
            blt $t2, $s0, Laco_Escrita      #Se $t2 for menor que $s0(i < N) continua escrevendo o vetor
            move $v0, $t0                   #Carrega o endereco do vetor para retorno da funcao
            jr $ra                          #Salta para funcao main Estrutura_Principal

    Erro:
        li $v0, 4            #Chamada de sistema para escrever strings      
        la $a0, msg_erro     #Carrega em $a0 a variavel "msg_erro"
        syscall              #Imprime a mensagem que esta em $a0
        jal Leitura_N        #Salta para o label de Leitura_N
