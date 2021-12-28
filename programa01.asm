#Programa que le um valor N maior que 0 e realiza a soma de 1 até N:
.data
msg1: .asciiz "\nEntre com um valor inteiro (N>1):" #msg1 recebe a mensagem do layout de entrada
msg2: .asciiz "\nO valor digitado N tem que ser maior que 1." #ms2 recebe a mensagem caso valor digitado seja menor ou igual a 1
msg3: .asciiz "\nA soma dos valores inteiros de 1 até N = " #msg 3 recebe a mensagem de layout de saida

.text

main:
    add		$t0, $zero, $zero		# limpeza do registrador
    add		$t1, $zero, $zero		# limpeza do registrador

    leitura_n:
        li $v0,4 #codigo pra imprimir strings
        la $a0,msg1 #carrega endereço da msg1 em a0
        syscall #chamada de sistema, vai ser impresso na tela a msg1
        li $v0,5 #codigo pra ler inteiro
        syscall #o valor digitado pelo usuario é atribuido pra v0
        add $s0,$v0,$zero #atribui o valor lido pra $s0
        addi $t3,$zero,1 #atribui 1 pra t3
        ble $s0,$t3, loop_erro #se o valor lido for menor ou igual a 1
        bge $s0,$t3, loop_soma #se o valor lido for maior que 1 executa a soma

        loop_soma:
            addi $t0,$t0,1 #t0 serve como contador
            add $t1,$t1,$t0 #soma em t1 o valor do contador atual
            bne	$t0, $s0,loop_soma	#se t0 é diferente de $s0 executa o loop_soma, $s0 é n e $t0 é o contador
            beq $t0,$s0, saida #se o t0 for igual ao valor de n sai do loop soma e vai pro label saida

        loop_erro: #loop ate que o usuario digite um valor valido
            li $v0,4 #codigo pra imprimir strings
            la $a0,msg2 #carrega endereço da msg1 em a0
            syscall #chamada de sistema, vai ser impresso na tela a msg2
            li $v0,4 #codigo pra imprimir strings
            la $a0,msg1 #carrega endereço da msg1 em a0
            syscall #chamada de sistema, vai ser lido o novo valor digitado
            li $v0,5 #codigo pra ler inteiro
            syscall #o valor digitado pelo usuario é atribuido pra v0
            add $s0,$v0,$zero #atribui o valor lido pra $s0
            addi $t3,$zero,1 #atribui 1 pra t3
            ble $s0,$t3, loop_erro #se o valor lido for menor ou igual a 1 vai executar o loop_erro dnv até que seja digitado um valor >1
            bge $s0,$t3, loop_soma #se o valor lido for maior que 1 executa a soma

    saida:
        li $v0,4 #codigo pra imprimir strings
        la $a0,msg3 #carrega endereco da string msg3
        syscall #vai imprimir a ms3
        li $v0,1 #codigo pra escrever inteiro
        add $a0,$zero,$t1 #atribui pra a0 o t1
        syscall #vai imprimir o resultado da soma