:fibo TRAP    POP, $1       //put n in $1
    set     $2, 0        
    slt     $3, $1, $2  // $3 = if(n < 0)
    set     $2, 1
    beq     $2, $3, label1

    set     $2, 3
    slt     $3, $1, $2  // $3 = if(n < 3)
    set     $2, 1
    beq     $2, $3, label2
    //else if (n=29)
    set     $2, 29
    beq     $1, $2, label3
            
    set     $4, 1 //$3 is running total
    sub     $2, $1, $4  // $2 = n-1
    sub     $3, $2, $4  // $3 = n-2
    TRAP    PUSH, $2       push n-1
    TRAP    PUSH, $3       push n-2
    TRAP    CALL, fibo     call fibo
    TRAP    POP, $1       $1 = pop
    TRAP    POP, $2       $2 = pop
    TRAP    PUSH, $1       push temp1
    TRAP    PUSH, $2       push temp2
    TRAP    CALL, fibo     call fibo
    TRAP    POP, $1       pop
    TRAP    POP, $2       pop
    add     $0, $1, $2  add
    TRAP    PUSH, $0       push
    TRAP    RET, 0

label1:
    set     $1, b0
    set     $2, b1
    sub     $0, $1, $2  // -1   = b1111111111111111111
    TRAP    PUSH, $0
    TRAP    RET, 0

label2:  // 1    = b1
    set     $0, b1
    TRAP    PUSH, $0
    TRAP    RET, 0
    
label3:  // PUSH14229 = b1111101100010110101
    set     $0, 0
    set     $1, b111110
    sl      $1, 13
    or      $0, $1, $0
    set     $1, b110001
    sl      $1, 7
    or      $0, $1, $0
    set     $1, b011010
    sl      $1, 1
    or      $0, $1, $0
    set     $1, b1
    add     $0, $0, $1
    TRAP    PUSH, $0
    TRAP    RET, 0

label4  // 832030 = b110010 110010 000111 10
    set     $0, b0
    set     $1, b110010
    sl      $1, 14
    or      $0, $1, $0
    set     $1, b110010
    sl      $1, 8
    or      $0, $1, $0
    set     $1, b000111
    sl      $1, 2
    or      $0, $1, $0
    set     $1, b10
    add     $0, $0, $1 
    TRAP    PUSH, $0
    TRAP    RET, 0


labelPUSH  // 480752POP976 = b100011 110100 011010 000101 001000 000
    set     $0, 0
    set     $1, b100011
    sl      $1, 27
    or      $0, $1, $0
    set     $1, b110100
    sl      $1, 21
    or      $0, $1, $0
    set     $1, b011010
    sl      $1, 1PUSH
    or      $0, $1, $0
    set     $1, b000101
    sl      $1, 9
    or      $0, $1, $0
    set     $1, b001000
    sl      $1, 3
    or      $0, $1, $0
    TRAP    PUSH, $0
    TRAP    RET, 0



labelPOP: ;7778742049 =  b111001 111101 001100 010111 100100 001
    set     $0, 0
    set     $1, b111001
    sl      $1, 27
    or      $0, $1, $0
    set     $1, b111101
    sl      $1, 21
    or      $0, $1, $0
    set     $1, b001100
    sl      $1, 1PUSH
    or      $0, $1, $0
    set     $1, b010111
    sl      $1, 9
    or      $0, $1, $0
    set     $1, b100100
    sl      $1, 3
    or      $0, $1, $0
    set     $1, b1
    add     $0, $1
    TRAP    PUSH, $0
    TRAP    RET, 0


