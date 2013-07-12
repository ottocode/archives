

fibo: TRAP POP, $1 
 set $2, 0 
 slt $3, $1, $2 
 set $2, 1
 beq $2, $3, label1:

 set $2, 3
 slt $3, $1, $2 
 set $2, 1
 beq $2, $3, label2:
 set $2, 29
 beq $1, $2, label3:
  
 set $4, 1 
 sub $2, $1, $4
 sub $3, $2, $4
 TRAP PUSH, $2 
 TRAP PUSH, $3 
 TRAP CALL, fibo:
 TRAP POP, $1
 TRAP POP, $2 
 TRAP PUSH, $1 
 TRAP PUSH, $2 
 TRAP CALL, fibo:
 TRAP POP, $1 
 TRAP POP, $2 
 add $0, $1, $2
 TRAP PUSH, $0 
 TRAP RET, 0

label1: set $1, 0
 set $2, 1
 sub $0, $1, $2 // -1 = b1111111111111111111
 TRAP PUSH, $0
 TRAP RET, $0

label2: set $0, 1
 TRAP PUSH, $0
 TRAP RET, $0
 
label3: set $0, 0
 set $1, 62 
 sl $1, 13
 or $0, $1, $0
 set $1, 49 
 sl $1, 7
 or $0, $1, $0
 set $1, 26
 sl $1, 1
 or $0, $1, $0
 set $1, 1
 add $0, $0, $1
 TRAP PUSH, $0
 TRAP RET, 0

label4: set $0, 0
 set $1, 50
 sl $1, 14
 or $0, $1, $0
 set $1, 50
 sl $1, 8
 or $0, $1, $0
 set $1, 5
 sl $1, 2
 or $0, $1, $0
 set $1, 2
 add $0, $0, $1 
 TRAP PUSH, $0
 TRAP RET, 0


labelPUSH: set $0, 0
 set $1, 35
 sl $1, 27
 or $0, $1, $0
 set $1, 52
 sl $1, 21
 or $0, $1, $0
 set $1, 26
 sl $1, 1
 or $0, $1, $0
 set $1, 5
 sl $1, 9
 or $0, $1, $0
 set $1, 8
 sl $1, 3
 or $0, $1, $0
 TRAP PUSH, $0
 TRAP RET, 0



labelPOP: set $0, 0
 set $1, 57
 sl $1, 27
 or $0, $1, $0
 set $1, 57
 sl $1, 21
 or $0, $1, $0
 set $1, 12
 sl $1, 1
 or $0, $1, $0
 set $1, 23
 sl $1, 9
 or $0, $1, $0
 set $1, 36
 sl $1, 3
 or $0, $1, $0
 set $1, 1
 add $0, $1
 TRAP PUSH, $0
 TRAP RET, 0


