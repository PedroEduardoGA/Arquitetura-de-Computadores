#Lê um valor inteiro N onde esse valor será usado para manipular um vetor, mostrará o somatório dos quadrados de 0 até N
.data
    array:
        .space 256 #reserva o espaco pro array, como é um array de inteiros, cada posicao ocupa 4Bytes, entao 64x4=256
    
    msg: .asciiz "\nSoma = " #msg de saida

.text

main:
    add $t0,$zero,$zero #registrador usado pra usar na manipulacao do array
    li $v0,5 #codigo pra ler inteiro
    syscall #o valor digitado pelo usuario é atribuido pra v0
    add $s0,$v0,$zero #atribui o valor lido pra $s0, s0 é o upTo

    storeValues:
        li $t1,0 #t1 vai ser o contador i
        for: #for usado para armazenar em cada posicao do vetor o ² de i
            beq $t1,$s0, computeSum #se o contador t1 é igual o valor de n(upTO) vai pro label computeSum
            
            mul $s2, $t1, $t1 #armazeno em s2 o valor da multiplicacao t1 x t1 (i x i)
            sw $s2,array($t0) #armazeno o valor de s2 no array na posicao t0, as posicoes variam de 4 em 4

            addi $t0,$t0,4 #incrementa o registrador que uso pra manipular o array, vai de 4 em 4
            addi $t1,$t1,1 #incremento o contador
            j for #salta pro label for novamente

    computeSum:
        li $t1,0 #t1 vai ser o contador i, é carregado o valor 0
        li $s2,0 #s2 vai ser o somatorio, é carregado o valor 0 
        move $t0,$zero #reseto o indice que é usado pra manipulacao do array
        for_2:
            beq $t1,$s0, return #se o contador t1 é igual o valor de n(upTO) vai pro label return

            lw $a0,array($t0) #carrega o valor do array na posicao t0 pro registrador a0
            add $s2,$s2,$a0 #somo o valor de a0 no somatorio s2

            addi $t0,$t0,4 #incrementa o registrador que uso pra manipular o array, vai de 4 em 4
            addi $t1,$t1,1 #incremento o contador
            j for_2 #salta pro label do for_2

return:
    li $v0,4 #codigo pra imprimir strings
    la $a0,msg #carrega endereço da msg2 de saida em a0
    syscall #chamada de sistema, vai ser impresso na tela a msg2 de saida
    li $v0,1 #codigo pra imprimir inteiro
    add $a0,$zero,$s2 #carrega o valor de s2 em a0
    syscall #chamada de sistema, vai ser impresso o inteiro s2 na tela

    li $v0,10 #codigo pra terminar a execucao
    syscall #chamada de sistema que finaliza a execucao 

