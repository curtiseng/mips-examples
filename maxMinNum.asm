    .data
min:        .word       0
max:        .word       0
xyz:        .word       28,16,32,64,128,256
msg_min:    .asciiz     "min: "
msg_max:    .asciiz     "max: "
msg_nl:     .asciiz     "\n"

# int main(void)
#
# local variable    register
#   int *p      $s0
#   int *end    $s1
#   int *min    $s2
#   int total   $s3
#
    .text
    .globl  main

main:
    la      $s0,xyz                 # p = foo
    addi    $s1,$s0,24              # end = p + 6

    la      $s2,min                 # point to min
    la      $s4,max                 # point to max
    lw      $t4,0($s0)              # fetch xyz[0]
    sw      $t4,0($s2)              # store in min
    sw      $t4,0($s4)              # store in max

main_loop:
    beq     $s0,$s1,main_done       # if (p == end) goto L2

    lw      $t0,0($s0)              # $t0 = *p
    addi    $s0,$s0,4               # p++
    
    lw      $t4,0($s2)              # fetch min
    slt     $t2,$t4,$t0             # *p < min?
    bne     $t2,$zero,main_loop     # no, loop
    
    sw      $t0,0($s2)              # store new/better min value
    lw      $t0,0($s0)
    
    lw      $t4,0($s4)              # fetch max
    slt     $t2,$t4,$t0             # *p > max?
    bne     $t2,1,main_loop     # no, loop
    
    sw      $t0,0($s4)
    
    j       main_loop

main_done:
    li      $v0,4
    la      $a0,msg_min
    syscall

    li      $v0,1
    lw      $a0,0($s2)              # get min value
    syscall

    li      $v0,4
    la      $a0,msg_max
    syscall
     
    li      $v0,1
    lw      $a0,0($s4)              # get max value
    syscall

    li      $v0,4
    la      $a0,msg_nl
    syscall

    # exit program
    li      $v0,10
    syscall