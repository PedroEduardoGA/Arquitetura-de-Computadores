#Programa que lê um valor N, informa se o N é primo ou não, caso seja mostrará os primos de 1 até N e os N primeiros numeros primos existentes:
.data
msg1: .asciiz "\nEntre com um valor N maior que 0:" #msg1 recebe a mensagem para entrar com o valor N
msg2: .asciiz "\nO valor digitado tem que ser maior que 0!" #ms2 recebe a mensagem caso valor digitado seja menor ou igual a 0
msg3: .asciiz "\nO numero digitado não é primo!" #msg 3 recebe a mensagem caso o numero nao seja um numero primo

msg4: .asciiz "\nO numero digitado é primo!" #msg 4 recebe a mensagem caso o numero seja um numero primo
msg4_ii: .asciiz "\n\nNumeros primos ate N:\n" #msg 4ii recebe a saida ii
msg4_iii: .asciiz "\n\nOs N primeiros numeros primos:\n" #msg 4iii recebe a mensagem iii de layout de saida
espaco: .asciiz " - " #espaco recebe uma string que vai servir pra ter um espaco entre os valores

.text

main: #label main
    addi $t0,$zero,1 #contador que vai ate N
    
    leitura_N: #label para leitura do valor N
        li $v0,4 #codigo pra imprimir strings
        la $a0,msg1 #carrega endereço da msg1 em a0
        syscall #chamada de sistema, vai ser impresso na tela a msg1
        li $v0,5 #codigo pra ler inteiro
        syscall #o valor digitado pelo usuario é atribuido pra v0
        add $s0,$v0,$zero #atribui o valor lido pra $s0->N
       
        add $t2,$zero,$s0 #atribui pra t2 o valor de N
        addi $t3,$zero,1 #atribui pra t3 o valor 1, vou usar t3 temporariamente pra verificar se o N = 1, pois se for ha um tratamento especial
        addi $t2,$t2,-1 #decrementa 1 do valor de t2, pois pra verificar se é primo vou até N-1
        
        ble $s0,$zero, loop_erro #se o valor lido for menor ou igual a 0
        beq $t3,$s0, saida_2 #se o N digitado for igual a 1, sai do loop
        bgt $s0,$zero, verifica_N #se o valor lido for maior que 0 executa a verificacao
        
        loop_erro: #loop ate que o usuario digite um valor valido
            li $v0,4 #codigo pra imprimir strings
            la $a0,msg2 #carrega endereço da msg2 em a0
            syscall #chamada de sistema, vai ser impresso na tela a msg2
            j leitura_N #salta pra leitura do N novamente

        verifica_N: #loop que serve pra verificar se o N digitado é um valor primo
            addi $t0,$t0,1 #incrementa o contador de 1 em 1
            bge $t0,$t2, saida_1i #se o t0 for maior ou igual que o valor de t2(N-1) sai da verificacao e vai pra saida
            
            div $t3,$s0,$t0 #t3 recebe o resultado inteiro da divisao de N pelo contador
            mfhi $t3 #t3 recebe o resto da divisao

            beq $t3,$zero, saida_2 #se o resto da divisao deu 0 entao N nao é primo
            j verifica_N #realizo o mesmo loop novamente

        imprimir_Primo: #labal que uso pra imprimir o valor de t0
            li $v0,1 #codigo pra escrever inteiro
            add $a0,$zero,$t0 #atribui pra a0 o t0
            syscall #vai imprimir o valor de t0
            li $v0,4 #codigo pra imprimir strings
            la $a0,espaco #carrega endereço da string espaco em a0
            syscall #chamada de sistema, vai ser impresso na tela a string espaco
            addi $t2,$t2,1 #incremento o t2, tem funcionalidade quando executo a tarefa de imprimir os N primeiros primos

            beq $t7,$zero, loop_ii #se a variavel de controle é igual a 0 eu estou executando a tarefa de imprimir os primos até N
            bne $t7,$zero, N_Primos #se a variavel de controle é igual a 1 eu estou executando a tarefa de imprimir os N primeiros numeros primos
 
    saida_1i: #label da primeira saida caso o numero digitado seja um numero primo
        li $v0,4 #codigo pra imprimir strings
        la $a0,msg4 #carrega endereço da msg4 em a0
        syscall #chamada de sistema, vai ser impresso na tela a msg4
        addi $t0,$zero,2 #atribuo 2 pro registrador t0

        li $v0,4 #codigo pra imprimir strings
        la $a0,msg4_ii #carrega endereço da segunda msg4 em a0
        syscall #chamada de sistema, vai ser impresso na tela a segunda msg4
        li $v0,1 #codigo pra escrever inteiro
        add $a0,$zero,$t0 #atribui pra a0 o t0
        syscall #vai imprimir o valor de t0 que é 2, ja que pra ter chego aki o valor de N é no minimo

        bne $s0,$t0, saida_1ii #se o N n for igual a 2 vou pra saida ii
        beq $s0,$t0, saida_1iii #se o N for igual a 2 eu vou pra saida iii

    saida_1ii: #label da segunda saida caso o N seja primo
        addi $t0,$zero,1 #inicializando o contador primario
        li $v0,4 #codigo pra imprimir strings
        la $a0,espaco #carrega endereço da string espaco em a0
        syscall #chamada de sistema, vai ser impresso na tela a string espaco
        add $t7,$zero,$zero #vou usar t7 como um valor de controle no label imprimir_Primo

        loop_ii: #loop que uso pra imprimir os valores primos até N
            addi $t1,$zero,1 #reseto o contador t1 para 1
            addi $t0,$t0,2 #incrementando o contador primario
            bgt $t0,$s0, saida_1iii #se o contador t0 é maior que o valor de N imprimiu os primos até N
            
        PrimosAt_N: #label que verifica quais valores de 3 até N são primos
            addi $t1,$t1,1 #incremento o contador secundario em 1
            bge $t1,$t0, imprimir_Primo #se o t0 for >= que o valor de t1 vai imprimir o primo na tela, se chegou até esse ponto o valor de t0 é primo
            
            div $t3,$t0,$t1 #t3 recebe o resultado inteiro da divisao de N pelo contador
            mfhi $t3 #t3 recebe o resto da divisao

            beq $t3,$zero, loop_ii #se o resto da divisao deu 0 entao o t0 atual nao é primo
            j PrimosAt_N #realizo o loop primosAt_N novamente

    saida_1iii: #label para a terceira saida caso N seja primo
        li $v0,4 #codigo pra imprimir strings
        la $a0,msg4_iii #carrega endereço da terceira ms4 de saida em a0
        syscall #chamada de sistema, vai ser impresso na tela a mensagem
    
        addi $t0,$zero,2 #atribuo 2 pro registrador t0

        li $v0,1 #codigo pra escrever inteiro
        add $a0,$zero,$t0 #atribui pra a0 o t0
        syscall #vai imprimir o valor de t0 que é 2
        li $v0,4 #codigo pra imprimir strings
        la $a0,espaco #carrega endereço da string espaco em a0
        syscall #chamada de sistema, vai ser impresso na tela a string espaco

        addi $t7,$zero,1 #t7 que é minha variavel de controle passa a valer 1
        addi $t0,$zero,1 #inicializando o contador primario
        addi $t2,$zero,1 #limpando registrador t2 e atribuindo 1 pra ele

        N_Primos: #label que imprimi os N primeiros numeros primos
            addi $t1,$zero,1 #resetando o contador t1
            addi $t0,$t0,2 #incrementando em 2 o contador primario
            beq $t2,$s0, Finaliza #imprimiu os N primeiros numeros primos

            loop_iii: #loop que verifica quais valores sao primos de 3 até o N-ésimo numero primo
                addi $t1,$t1,1 #incremento o contador secundario em 1
                bge $t1,$t0, imprimir_Primo #se o t1 for >= que o valor de t0 vai imprimir o primo na tela
            
                div $t3,$t0,$t1 #t3 recebe o resultado inteiro da divisao de N pelo contador
                mfhi $t3 #t3 recebe o resto da divisao

                beq $t3,$zero, N_Primos #se o resto da divisao deu 0 entao o t0 atual nao é primo
                j loop_iii #executo o loop novamente
  
    saida_2:
        li $v0,4 #codigo pra imprimir strings
        la $a0,msg3 #carrega endereço da msg3 em a0
        syscall #chamada de sistema, vai ser impresso na tela a msg3
    
    Finaliza: #label de encerramento da execucao do programa
        li $v0,10 #codigo pra terminar a execucao
        syscall #chamada de sistema que finaliza a execucao       

