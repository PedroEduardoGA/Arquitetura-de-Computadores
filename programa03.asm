#Programa que lê de dois números inteiros (A e B) e fornece todos os múltiplos de A no intervalo de A até AxB:
.data
msg1: .asciiz "\nEntre com um valor A inteiro maior que 0:" #msg1 recebe a mensagem para entrar com o valor A
msg1_1: .asciiz "\nEntre com outro valor B inteiro maior que 0:" #msg1 recebe a mensagem para entrar com o valor B

msg2: .asciiz "\nO valor digitado tem que ser maior que 0!" #ms2 recebe a mensagem caso valor digitado seja menor ou igual a 0
msg2_1: .asciiz "\nEntre com um valor maior que 0:" #msg2_1 recebe a mensagem para entrar com o valor maior que 0, para usar no loop_erro

msg3: .asciiz "\nMultiplo de A: " #msg 3 recebe a mensagem de layout de saida
msg4: .asciiz "\nPrograma finalizado!" #msg 4 recebe a mensagem de layout de saida

.text

main: #label main
    add		$t0, $zero, $zero		# limpeza do registrador
    add		$t1, $zero, $zero		# limpeza do registrador
    #t0 vai armazenar o valor de A, t1 vai armazenar o valor de B, t2 vai armazenar o valor de AxB, t3 vai ser usado como auxiliar, t4 recebe o valor da divisao t6/t0, t5 recebe o resto dessa divisao e t6 sera o contador!

    leitura_A: #label para leitura do valor A
        li $v0,4 #codigo pra imprimir strings
        la $a0,msg1 #carrega endereço da msg1 em a0
        syscall #chamada de sistema, vai ser impresso na tela a msg1
        li $v0,5 #codigo pra ler inteiro
        syscall #o valor digitado pelo usuario é atribuido pra v0
        add $s0,$v0,$zero #atribui o valor lido pra $s0->A
       
        ble $s0,$zero, loop_erro #se o valor lido for menor ou igual a 0
        bge $s0,$zero, leitura_B #se o valor lido for maior que 0 executa a soma

    leitura_B: #label para leitura do valor B
        add $t0,$zero,$s0 #atribui o valor de s0->A pro registrador t0
           
        li $v0,4 #codigo pra imprimir strings
        la $a0,msg1_1 #carrega endereço da msg1 em a0
        syscall #chamada de sistema, vai ser impresso na tela a msg1
        li $v0,5 #codigo pra ler inteiro
        syscall #o valor digitado pelo usuario é atribuido pra v0
        add $s0,$v0,$zero #atribui o valor lido pra $s0->B
        add $t1,$zero,$s0 #atribui o valor de s0 para t1

        ble $s0,$zero, loop_erro #se o valor lido for menor ou igual a 0
        bge $s0,$zero, multiplicacao_AxB #se o valor lido for maior que 0 executa a multiplicacao
            
        loop_erro: #loop ate que o usuario digite um valor valido
            li $v0,4 #codigo pra imprimir strings
            la $a0,msg2 #carrega endereço da msg2 em a0
            syscall #chamada de sistema, vai ser impresso na tela a msg2
            li $v0,4 #codigo pra imprimir strings
            la $a0,msg2_1 #carrega endereço da msg2_1 em a0
            syscall #chamada de sistema, vai ser impresso a mensagem
            li $v0,5 #codigo pra ler inteiro
            syscall #o valor digitado pelo usuario é atribuido pra v0
            add $s0,$v0,$zero #atribui o valor lido pra $s0

            ble $s0,$zero, loop_erro #se o valor lido for menor ou igual a 1 vai executar o loop_erro dnv até que seja digitado um valor >1
            beq $t1,$zero, leitura_B #se chega nessa comparacao o valor digitado foi maior que 0, se o t1 for igual a 0 nao executei a leitura do numero B ainda
            bge $s0,$zero, multiplicacao_AxB #se o valor lido for maior que 0 executa a soma

    multiplicacao_AxB: #label para multiplicar os valores validos de t0 e t1(AxB)
        add $t1,$zero,$s0 #registrador t1 recebe o valor de s0->B que agora vai ser um valor valido 
        mul $t2,$t0,$t1 #guardo no registrador t2 a multiplicacao do t0xt1 equivalente (AxB)
        add $t6,$zero,$t0 #t6 serve como contador pra ser usado no intervalo A - AxB
        j loop_divisores #salta pro label de verificar os divisores

    loop_divisores: #loop que verifica os multiplos de A no intervalo A - AxB
        bgt $t6,$t2, saida #se o t6 for maior que o valor de t2(AxB) sai do loop e vai pro label saida

        div $t4,$t6,$t0 #t4 recebe o resultado inteiro da divisao do contador t6 por A
        mfhi $t5 #t5 recebe o resto da divisao
        add $t3,$t6,$zero #t3 recebe o valor atual do contador
        addi $t6,$t6,1 #incrementa o contador em 1
        
        beq $t5,$zero, resto0 #se t5 é igual a 0 entao t4 é multiplo de A
        j loop_divisores #salto pro loop novamente
            
        resto0: #label que verifica se o valor é maior ou igual ao valor de A, assim se enquadra no intervalo A - AxB
            bge $t3,$t0, imprimir #valor de t3 é maior ou igual que o t0(A)
            j loop_divisores #salto pro loop_divisores

        imprimir: #label que imprime na tela o valor que é multiplo de A
            li $v0,4 #codigo pra imprimir strings
            la $a0,msg3 #carrega endereco da string msg3
            syscall #vai imprimir a msg3
            li $v0,1 #codigo pra escrever inteiro
            add $a0,$zero,$t3 #atribui pra a0 o t3
            syscall #vai imprimir o resultado do contador
            j loop_divisores #salto pro loop_divisores
            
    saida: #label exit(de saida)
        li $v0,4 #codigo pra imprimir strings
        la $a0,msg4 #carrega endereco da string msg4
        syscall #vai imprimir a msg4
        
        li $v0,10 #codigo pra terminar a execucao
        syscall #chamada de sistema que finaliza a execucao
        