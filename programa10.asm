#Programa le um vetor de N posições e apresenta como saida: quantidade de numeros perfeitos, quantidade de numeros semi-primos
#e o valor do somatório dos perfeitos menos o somatório dos semi-primos
.data 
        entrada: .asciiz "Entre com o valor da posicao["                                                                        #Cria uma variavel que ira guardar o texto de entrada de Vet
        fim_vet: .asciiz "]:"                                                                                                   #Cria uma variavel que ira guardar o caractere ]
        ent_N: .asciiz "Entre com um valor inteiro(N > 0). "                                                                    #Cria uma variavel que ira guardar o texto para entrar com valor N
        msg_erro: .asciiz "Erro! O valor tem que ser um inteiro maior que 1.\n "                                                #Cria uma variavel que ira guardar o texto de erro caso o numero digitado seja 0 ou negativo
        saida: .asciiz "\nO somatorio dos numeros perfeitos: "                                                                  #Cria uma variavel que ira guardar a mensagem do layout de saida que mostra a soma dos perfeitos
        saida2: .asciiz "\nO somatorio dos numeros semi primos: "                                                               #Cria uma variavel que ira guardar a mensagem do layout de saida que mostra a soma dos semi primos
        saida3: .asciiz "\nO resultado do somatorio dos numeros perfeitos menos o somatorio dos numeros semi primos: "          #Cria uma variavel que ira guardar a mensagem do layout de saida
        N_existePerfeito: .asciiz "\nNao ha inteiros que sao numeros perfeitos! "                                               #Cria uma variavel que ira guardar a mensagem caso nao haja numeros perfeitos
        N_existeSemiPrimo: .asciiz "\nNao ha inteiros que sao numeros semi primos! "                                            #Cria uma variavel que ira guardar a mensagem caso nao haja numeros semi primo
.align 2
vet: .space 150

.text

.main: 

    add $s0, $zero, $zero       #Inicializando variavel s0 (N) que define o tamanho do vetor
    add $s1, $zero, $zero       #Inicializando variavel s1 que representa o somatorio dos numeros que forem perfeitos
    add $s2, $zero, $zero       #Inicializando variavel s2 que representa o somatorio dos numeros que forem semi primos

    Leitura_N: 
        li $v0, 4               #Codigo SysCall para escrever strings
        la $a0, ent_N           #Armazena em $a0 o endereco da variavel ent_N
        syscall                 #Vai imprimir a mensagem que esta em $a0
        li $v0, 5               #Codigo SysCall para ler inteiros
        syscall                 #Chamada de sistema para leitura de inteiro
        ble $v0, 0, Erro        #Se o valor digitado for menor ou igual que 0 salta para o label Erro

        add $s0, $v0, $zero     #Armazena em $s0 o valor lido

    Estrutura_Main:
        la $a0, vet             #Armazena em $a0 o endereco do vetor
        j Leitura_Vetor         #Salta para o label de leitura do vetor

    Segunda_Estrutura:
        move $a0, $v0           #Coloca o endereco do vetor retornado da funcao "leitura" em $a0
        jal Escrita             #Salta para o label de escrita do vetor
        li $v0, 10              #Codigo usado para finalizar o programa
        syscall                 #Programa finalizado

    Leitura_Vetor:
        move $t0, $a0           #Move para $t0 o endereco base do vetor
        move $t1, $t0           #Armazena em $t1 o valor de $t0
        li $t2, 0               #Inicializa $t2 com 0 que sera o contador (i)

        Laco_Leitura:  
            la $a0, entrada         #Carrega em $a0 o endereco da variavel "entrada"
            li $v0, 4               #Codigo SysCall para escrever strings
            syscall                 #Vai imprimir a mensagem que esta em $a0
            move $a0, $t2           #Move para $a0 o valor do $t2(i)
            li $v0, 1               #Codigo SysCall para escrever inteiros
            syscall                 #Chamada de sistema para escrita do inteiro
            la $a0, fim_vet         #Armazena em $a0 o caractere ]
            li $v0, 4               #Codigo SysCall para escrever strings
            syscall                 #Vai imprimir a mensagem que esta em $a0 "]"

            li $v0, 5               #Codigo SysCall para ler inteiros
            syscall                 #Chamada de sistema para leitura do inteiro
            add $t7, $v0, $zero     #Armazena em $t7 o valor lido
            j Teste_Perfeito        #Salta para o label que verifica se o valor digitado eh um numero perfeito

        Armazenamento:
            sw $t7, ($t1)                   #Armazena em $v0 o inteiro lido
            add $t1, $t1, 4                 #$t1 recebe o valor do vetor (i+1)
            addi $t2, $t2, 1                #Incrementa $t2 em i+1
            blt $t2, $s0, Laco_Leitura      #Se o valor de $t2(i) for menor que $s0(N) salta para o label de leitura novamente

            move $v0, $t0                   #Move para $v0 o endereco base do vetor
            j Segunda_Estrutura             #Salta para a segunda parte da estrutura principal

    Escrita:
        move $t0, $a0           #Armazena em $t0 o valor base do vetor
        move $t1, $t0           #$t1 recebe o valor de $t0
        li $t2, 0               #Inicializa $t2 com 0 que sera o contador (i)
        
        Laco_Escrita:  
            lw $a0, ($t1)                       #Carrega em $a0 o valor da posicao (i) do vetor
            li $v0, 1                           #Codigo SysCall para escrever inteiros        
            syscall                             #Chamada de sistema para escrita do inteiro
            li $a0, 32                          #Codigo SysCall de ASCII para escrever espaco
            li $v0, 11                          #Codigo SysCall para imprimir caracteres
            syscall                             #Imprime o espaco
            add $t1, $t1, 4                     #$t1 recebe a posicao (i+1) do vetor
            addi $t2, $t2, 1                    #Incrementa o $t2 (i) do vetor em +1
            blt $t2, $s0, Laco_Escrita          #Se $t2(i) for menor que $s0(N), vai para o laco de escrita novamente
            beq $s1,$zero, Nao_ExistePerfeito   #Se o somatorio dos numeros perfeitos for igual a zero vai para o label que informa que nao existe numeros perfeitos
        
            la $a0, saida                       #$a0 recebe a mensagem do layout de saida que mostra o somatorio dos numeros perfeitos em $a0
            li $v0, 4                           #Codigo SysCall para escrever strings
            syscall                             #Vai imprimir a mensagem que esta em $a0 do somatorio 
            move $a0, $s1                       #Atribui pra $a0 o valor de $s1
            li $v0, 1                           #Codigo SysCall para escrever inteiros        
            syscall                             #Mostra na tela o somatorio dos numeros perfeitos

        SaidaSemi:
            beq $s2,$zero, Nao_ExisteSemiPrimo            #Se o somatorio dos numeros semi primos for igual a zero vai para o label que informa que nao existe semi primos
            
            la $a0, saida2                                #Carrega a mensagem que define o somatorio dos numeros semi primos
            li $v0, 4                                     #Codigo SysCall para escrever strings
            syscall                                       #Vai imprimir a mensagem que esta em $a0 de saida 
            move $a0, $s2                                 #Atribui pra $a0 o valor de $s2 que eh o somatorio dos numeros semi primos
            li $v0, 1                                     #Codigo SysCall para escrever inteiro        
            syscall                                       #Mostra na tela o somatorio dos numeros semi primos

            SaidaTotal:
                sub $s3,$s1,$s2                           #Atribui para $t3 a subtracao dos somatorios calculados
                la $a0, saida3                            #Carrega a mensagem do layout de saida em $a0
                li $v0, 4                                 #Codigo SysCall para escrever strings
                syscall                                   #Vai imprimir a mensagem que esta em $a0 de saida 
                move $a0, $s3                             #Atribui pra $a0 o valor de $s3 
                li $v0, 1                                 #Codigo SysCall para escrever inteiro      
                syscall                                   #Mostra o inteiro na tela (Resultado final)

                move $v0, $t0                             #Move para $v0 o endereco base do vetor
                jr $ra                                    #Retorna pro label Estrutura_Principal

    Erro:
        li $v0, 4                     #Codigo SysCall para escrever strings      
        la $a0, msg_erro              #Armazena em $a0 o endereco da variavel msg_erro
        syscall                       #vai imprimir a mensagem que esta em $a0
        jal Leitura_N                 #Salta pro label de leitura do N novamente

    Teste_Perfeito:
	    li $t3, 1                     #Carrega 1 em $t3 sera usado como contador
	    li $t4, 0                     #Inicializa $t4 com 0, sera usado como o somatorio dos divisores
	    beq $t7, 1, Teste_SemiPrimo   #Se o valor lido for 1 o numero nao é perfeito
	
        Loop:	
	        add $t3, $t3, 1                     #Incremento do contador $t3 em +1
	        bge $t3, $t7, Resposta_Perfeito 	#Se t3 é igual o valor lido vai pra resposta da funcao
	
	        div $t7, $t3                        #Divide o valor lido pelo contandor $t3 (valor/i)
	        mfhi $t5                            #$t5 recebe o resto da divisao
	
	        beq $t5, $zero, Somatorio           #Se $t5 for igual 0 vai pro label que soma $t4 no somatorio dos divisores
	        j Loop                              #Executa o loop novamente
	
            Somatorio:
	            add $t4, $t4, $t3               #Incrementa o $t4(somatorio dos divisores) com o $t3(contador atual)
	            j Loop                          #Executa o loop novamente 

        Resposta_Perfeito:
	        add $t4, $t4, 1         #Incrementa o $t4(somatorio dos divisores) em +1
	        beq $t4, $t7, Pefeito   #Se o $t4 for igual ao valor lido, entao o $t7 é perfeito
            j Teste_SemiPrimo       #Salta para o label que testa se o valor lido é semi primo
	
        Pefeito:
            add $s1,$s1,$t7         #Adiciona o numero lido ao somatorio $s1
            j Teste_SemiPrimo       #Salta para o label que testa se o valor lido é semi primo

    Teste_SemiPrimo: 
        li $t3, 0	                #Inicializa $t3 com zero(a = 0)
        li $t4, 0	                #Inicializa $t4 com zero(b = 0)
	    li $t5, 0	                #Inicializa $t5 com zero(resto = 0)
	    li $t6, 0	                #Inicializa $t6 com zero que sera o contador dos primos
	
        For1:	
            li $t4, 0                   #Reseta $t4 com zero(b = 0)
	        add $t3, $t3, 1             #Incrementa o $t3 em +1
	
        For2: 
            add $t4, $t4, 1             #Incrementa o $t4 em +1
	        mul $t5, $t3, $t4           #$t5 recebe a multiplicacao de $t3 x $t4(a x b)
  
	        beq $t5, $t7, Test_Primo    #Se a multiplicacao de $t5 for igual ao valor lido vai verificar se o valor é primo
	        j Continua_Iteracao         #Caso não for continua a verificacao

    Test_Primo:
	    li $t6, 0                   #Carrega zero em $t6
   
	    move $a1, $t3               #Atribui para $a1 o valor do (a) atual
	    jal Primo                   #Salta para o label que verifica se o valor de $t3(a) é primo
	    add $t6, $t6, $v1           #Incrementa em $t6 +1 caso o valor seja primo, 0 caso contrario
	
	    move $a1, $t4               #Atribui para $a1 o valor do (b) atual
	    jal Primo                   #Salta para o label que verifica se o valor de $t4(b) é primo
	    add $t6, $t6, $v1           #Incrementa em $t6 +1 caso o valor seja primo, 0 caso contrario
	
	    beq $t6, 2, SemiPrimo       #Se o valor de $t6 for igual a 2 então o valor lido é um semi primo

    Continua_Iteracao:   

	    blt $t4, $t7, For2          #Se o valor de $t4 for menor que o valor lido, salta para o label for2 que incrementa o valor de $t4(b)
	    blt $t3, $t7, For1          #Se o valor de $t3 for menor que o valor lido, salta para o label for1 que incrementa o valor de $t3(a)
	
	    j Armazenamento             #Salta para o label de armazenamento direto, pois o valor lido nao é semi primo

        SemiPrimo: 
	        add $s2,$s2,$t7                 #Adiciona o numero lido que eh semi primo ao somatorio $s2
            j Armazenamento                 #Salta para o label armazenamento

        Primo:
	        move $s3, $a1		            #Atribui para $s3 o valor de $a1
	        li $t8, 2		                #Inicializa o registrador temporario $t8(i) com 2
	
	        
	        beq $s3, 1, NaoEh_Primo	        #Trata o caso especial do valor de $s3 ser 1 que nao é um valor primo
	        beq $s3, 2, Eh_Primo	        #Trata o caso especial do valor de $s3 ser 2 que é um valor primo
	
        ForPrimo:	 
            div  $s3, $t8		            #Divive o valor de $s3 pelo contador $t8(i)
	        mfhi $t9		                #$t9 recebe o resto da divisão acima
	
	        beq, $t9, $zero, NaoEh_Primo	#Se o resto da divisão($t9) for zero o valor não é primo
	
	        add $t8, $t8, 1 	            #Incrementa o contador $t8(i) em +1
	        blt $t8, $s3, ForPrimo	        #Se o valor do contador é menor que o valor que esta sendo verificado executa o loop novamente

	        j Eh_Primo                      #Salta para o label que retorna em $v1 o valor 1 que representa que o valor é primo

        NaoEh_Primo:
	        li $v1, 0	                    #Caso nao seja primo o retorno da verificacao é 0
	        jr $ra		                    #Retorna para o ponto em que o label foi chamado
	
        Eh_Primo: 
	        li $v1, 1	                    #Caso seja primo o retorno da verificacao é 1
	        jr $ra		                    #Retorna para o ponto em que o label foi chamado

    Nao_ExistePerfeito:
        li $v0, 4                           #Codigo SysCall para escrever string     
        la $a0, N_existePerfeito            #Carrega a mensagem que estava na memoria da variavel "msg_erro" para o registrador de argumento $a0
        syscall                             #Imprime o valor de $a0 na tela
        j SaidaSemi                         #Salta para o label que mostra se ha valores semi primos

    Nao_ExisteSemiPrimo:
        li $v0, 4                           #Codigo SysCall para escrever strings      
        la $a0, N_existeSemiPrimo           #Carrega a mensagem que informa que nao existe numero semi primo, para o registrador de argumento $a0
        syscall                             #Imprime o valor de $a0 na tela
        j SaidaTotal                        #Salta para o label SaidaTotal que mostra o resultado final