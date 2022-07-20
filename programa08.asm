#Programa le um vetor de N posições e soma os valores pares do vetor
.data 
        msg_entrada: .asciiz "Entre com o valor da posicao["                            #Armazena na memoria o texto de entrada
        fim_vet: .asciiz "]:"                                                           #Armazena na memoria um colchete para formatacao 
        msg_valorN: .asciiz "Entre com um valor inteiro(N>1). "                         #Armazena na memoria a mensagem de leitura do N
        Mais: .asciiz " + "                                                             #Armazena na memoria o caractere do +
        Equal: .asciiz " = "                                                            #Armazena na memoria o caractere do =
        msg_pares_inexistente: .asciiz "Não há ocorrencia de numeros pares no vetor!"   #Armazena na memoria a mensagem de saida caso nao exista valores pares no vetor
        msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 1.\n"         #Armazena na variavel a mensagem de erro
.align 2
vet: .space 150

.text

.main: 
    Leitura_N: 
        li $v0, 4               #Chamada de sistema para escrita de string
        la $a0, msg_valorN      #Armazena em $a0 o endereco da string variavel de entrada com valor n 
        syscall                 #Imprime o conteudo de $a0
        li $v0, 5               #Chamada de sistema para leitura de inteiro
        syscall                 #O inteiro foi lido e esta em $v0
        ble $v0, 0, Erro        #Caso o valor lido seja igual ou menor que 0, salta para o label Erro
        add $s0, $v0, $zero     #$s0 recebe o valor que foi lido

    Estrutura_Principal:
        la $a0, vet             #$a0 recebe o endereco do vetor
        jal Leitura_Elementos   #Salta para o label de leitura dos elementos do vetor
        move $a0, $v0           #Armazena em $a0 o valor retornado do label "Leitura_Elementos"
        jal Somatorio_Pares     #Salta para o label que soma os valores pares do vetor 
        li $v0, 10              #Codigo de finalizacao do programa
        syscall                 #Chamada de sistema que finaliza o programa

    Leitura_Elementos:
        move $t0, $a0        #Armazena em $t0 o endereco base do vetor
        move $t1, $t0        #$t1 recebe o valor de $t0
        li $t2, 0            #Inicializa $t2 com 0 que vai servir como contador (i)
        
        Laco_Leitura:  
            la $a0, msg_entrada         #Carrega endereco da mensagem de entrada em $a0
            li $v0, 4                   #Codigo para escrever strings
            syscall                     #Chamada de sistema para escrita da string
            move $a0, $t2               #$a0 recebe o valor de $t2 que serve como contador
            li $v0, 1                   #Codigo para escrita de inteiros
            syscall                     #Chamada de sistema para escrita do inteiro
            la $a0, fim_vet             #Carrega em $a0 o "]"
            li $v0, 4                   #Codigo para escrever strings
            syscall                     #Chamada de sistema para escrita da string
            li $v0, 5                   #Codigo para leitura de inteiros
            syscall                     #Chamada de sistema que le o inteiro
            sw $v0, ($t1)               #Armazena o valor lido na posicao i
            add $t1, $t1, 4             #Armazena em $t1 o valor da posicao i+1
            addi $t2, $t2, 1            #$t2 eh incrementado em +1
            blt $t2, $s0, Laco_Leitura  #Se o contador for menor que o valor de $s0(N) salta para o laco de leitura novamente
            move $v0, $t0               #Armazena em $v0 o valor base do vetor
            jr $ra                      #Retorna para o ponto em que foi chamado esse label

    Somatorio_Pares:
        move $t0, $a0                   #Armazena em $t0 o endereco base do vetor
        move $t1, $t0                   #$t1 recebe o valor de $t0
        li $t2, 0                       #Inicializa $t2 com 0 que vai servir como contador (i)
        li $t3, 0                       #Inicializa $t3 com 0 que sera usado para armazenar a soma dos valores pares
        li $t4, 0                       #Inicializa o registrador que sera usado como booleano para verificacao dos pares
       
        Laco_Vetor:                    
            lw $s4, ($t1)                     #$s4 recebe o valor da posicao (i) do vetor
            li $s5, 2                         #Carrega imediatamente 2 em $s5 para verificacao do numero par
            div $s4, $s5                      #Divide o valor da posicao atual por 2
            mflo $s1                          #$s1 recebe a parte inteira da divisao
            mfhi $s2                          #$s2 recebe o resto da divisao
            bne	$s2, 0, Continua	          #Se o resto da divisao nao eh igual a 0 o valor nao eh par 
            add $t3, $t3, $s4                 #Caso o valor seja igual a 0, ele eh somado no somatorio dos pares
            beq	$t4, 0, Pares	              #Se $t4 foi igual a 0 esse eh o primeiro valor par do vetor
            li $v0, 4                         #Codigo para escrever strings      
            la $a0, Mais                      #Carrega em $a0 o caractere "+"
            syscall                           #Chamada de sistema para escrita da string

        Pares:
            li $t4, 1                        #Atribui 1 para $t4 ou seja existem valores pares
            lw $a0, ($t1)                    #Carrega em $a0 o elemento da posicao (i) 
            li $v0, 1                        #Codigo para escrita de inteiros        
            syscall                          #Imprime o inteiro

        Continua:
            add $t1, $t1, 4                  #Incrementa $t1 em 4, que vai para proxima posicao do vetor       
            addi $t2, $t2, 1                 #Incrementa $t2 (i+1)
            blt	$t2, $s0, Laco_Vetor         #Se o contador for menor que o valor de $s0(N) salta para o laco de verificacao(Laco_Vetor)

        Saida:  
            beq	$t4, 0, Zero_Pares	        #Se $t4 for igual a 0(false) entao nao existem valores pares no vetor
            li $v0, 4                       #Codigo para escrever strings      
            la $a0, Equal                   #Armazena em $a0 o caractere (=)
            syscall                         #Chamada de sistema para escrita da string
            move $a0, $t3                   #$a0 recebe o valor de $t3(Somatorio dos pares
            li $v0, 1                       #Codigo para escrita de inteiros        
            syscall                         #Imprime o inteiro
                
        Recupera:
            move $v0, $t0                #Move para $v0 o valor de $t0(Base do vetor)
            jr $ra                       #Retorna para a Estrutura_Principal

    Zero_Pares:
        li $v0, 4                      #Codigo para escrever strings      
        la $a0, msg_pares_inexistente  #Carrega em $a0 a mensagem de saida caso nao haja pares
        syscall                        #Chamada de sistema para escrita da string
        li $v0, 10                     #Codigo usado para finalizar o programa
        syscall                        #Finaliza o programa

    Erro:
        li $v0, 4                      #Codigo para escrever strings      
        la $a0, msg_erro               #Armazena em $a0 a mensagem da variavel "msg_erro"
        syscall                        #Chamada de sistema para escrita da string
        jal Leitura_N                  #Salta para o label para leitura do N novamente