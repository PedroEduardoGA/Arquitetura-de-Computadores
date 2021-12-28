#Programa que le um vetor com 8 valores e realiza a soma dos valores positivos e negativos separadamente:
.data
msgS1: .asciiz "\nA soma dos valores positivos = " #msg 1 de saida
msgS2: .asciiz "\nA soma dos valores negativos = " #msg 2 de saida
vetor: .word -2,4,7,-3,0,-3,5,6 #label vetor recebe o vetor

.text
    
    li $t0,8 #carrega imediatamente o valor 8 no registrador t0
    la $t1,vetor #carrega o endereco para o vetor
    
    add		$t3, $zero, $zero		# limpeza do registrador que recebera a soma dos valores positivos
    add		$t4, $zero, $zero		# limpeza do registrador que recebera a soma dos valores negativos

    loop:
        beq	$t0, $zero, saida	#quando contador for igual a 0 sai do loop
        
        lw $t2, 0($t1) #carrego a posicao do vetor
        
        addi $t1, $t1, 4 #atribui pra t1 a proxima posicao do vetor
        addi $t0,$t0,-1 #decrementa o contador em -1
        
        blt $t2,$zero,Soma_negativa #se t2 for menor que zero vai pro soma negativa
        bge $t2,$zero,Soma_positiva #se t2 for maior ou igual a zero vai pra soma positva
        j loop #vai executar o looping novamente

    Soma_positiva:
        add $t3,$t3,$t2 #adiciona o valor de t2 no somatorio dos valores positivos
        j loop #salta pro loop novamente

    Soma_negativa:
        add $t4,$t4,$t2#adiciona o valor de t2 no somatorio dos valores negativos
        j loop #salta pro loop novamente

    saida:
        li $v0,4 #codigo pra imprimir strings
        la $a0,msgS1 #carrega endereco da string msg2
        syscall #vai imprimir a msg2
        li $v0,1 #codigo pra escrever inteiro
        add $a0,$zero,$t3 #a0 recebe o valor do somatorio dos valores positivos
        syscall #vai imprimir o inteiro t3 na tela

        li $v0,4 #codigo pra imprimir strings
        la $a0,msgS2 #carrega endereco da string msg2
        syscall #vai imprimir a msg2
        li $v0,1 #codigo pra escrever inteiro
        add $a0,$zero,$t4 #a0 recebe o valor do somatorio dos valores negativos
        syscall #vai imprimir o inteiro t4 na tela

        li $v0,10 #codigo pra terminar a execucao
        syscall #chamada de sistema que finaliza a execucao