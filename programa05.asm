#Programa lê um valor inteiro positivo e informa se o numero é perfeito ou não:
.data
msg1: .asciiz "\nEntre com um valor n inteiro positivo:" #msg1 recebe a mensagem para entrar com o valor
msg_saida1: .asciiz "\nValor perfeito!" #msg 1 de saida caso o valor seja perfeito
msg_saida2: .asciiz "\nValor não perfeito!" #msg 2 de saida caso o valor nao seja perfeito

.text

leitura:
    li $v0,4 #codigo pra imprimir strings
    la $a0,msg1 #carrega endereço da msg1 em a0
    syscall #chamada de sistema, vai ser impresso na tela a msg1
    li $v0,5 #codigo pra ler inteiro
    syscall #o valor digitado pelo usuario é atribuido pra v0
    add $s0,$v0,$zero #atribui o valor lido pra $s0->n

testPerfect:
	li $t1, 1 #t1 sera usado como contador
	li $t2, 0 #t2 sera usado como o somatorio dos divisores
	move $t7, $ra #t7 recebe o registrador $ra
	beq $s0, 1, nNaoPefeito #se o valor lido for 1 o n nao é perfeito
	
loop:	
	add $t1, $t1, 1 #incremento do contador
	bge $t1, $s0, retorno	#se t1 é igual o valor lido vai pra resposta da funcao
	
	div $s0, $t1 #divide o n pelo contandor n/i
	mfhi $t3 #t3 recebe o resto
	
	beq $t3, $zero, incrementaSomatorio #se t3 == 0 vai pro label que soma t3 no somatorio dos divisores
	
	j loop #executa o loop novamente
	
incrementaSomatorio:
	add $t2, $t2, $t1 #incrementa o somatorio dos divisores com o contador atual
	j loop #executa o loop novamente 

	
retorno:
	add $t2, $t2, 1 #incrementa o somatorio em 1
	beq $t2, $s0, nPefeito #se o somatorio dos divisores for igual a n, entao n é perfeito
	bne $t2, $s0, nNaoPefeito #se o somatorio dos divisores nao for igual a n, entao n nao é perfeito
	
nPefeito:
	li $v0,4 #codigo pra imprimir strings
    la $a0,msg_saida1 #carrega endereço da msg1 de saida em a0
    syscall #chamada de sistema, vai ser impresso na tela a msg1 de saida
    j finaliza #salta pra finalizacao do programa
	
nNaoPefeito:
	li $v0,4 #codigo pra imprimir strings
    la $a0,msg_saida2 #carrega endereço da msg2 de saida em a0
    syscall #chamada de sistema, vai ser impresso na tela a msg2 de saida

finaliza:
    li $v0,10 #codigo pra terminar a execucao
    syscall #chamada de sistema que finaliza a execucao