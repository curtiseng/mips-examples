    .data
size: .word 9
array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
newLine: .asciiz "\n"

    .text
        .globl main
main:
    la $t1, size # get the address of variable size
    la $t2, array # get the address of variable array
    lw $t3, 0($t1) # fetch the value of Size to register $t3
    sll $t3, $t3, 2 # left shift logic, now $t3 contains Size*4
    addu $t7, $t2, $t3 # $t5 contains address of end of string
    addi $t8, $zero, 0
    
beforeReverse:
    beq $t8, $t3, reverseLoop
    lw $t6, array($t8)
    addi $t8, $t8, 4
    
    li $v0, 1
    move $a0, $t6
    syscall
    
    j beforeReverse

reverseLoop:
    addi $t7, $t7, -4 # moves pointer backwards
    lw $t5, 0($t2)
    lw $t0, 0($t7)
    sw $t5, ($t7)    # interchange
    sw $t0, ($t2)   # contents
    addi $t2, $t2, 4 # moves pointer forward
    blt $t2, $t7, reverseLoop # <
   
    addi $t8, $zero, 0
    li $v0, 4
    la $a0, newLine
    syscall
afterReverse:
    beq $t8, $t3, exit
    lw $t6, array($t8)
    addi $t8, $t8, 4
    
    li $v0, 1
    move $a0, $t6
    syscall
    
    j afterReverse
exit:
    li $v0, 10
    syscall
    
    
