
tagA: add $3, $2, $1
set $0, 0
lw $4, $0, $3
set $0, 1
lw $5, $0, $3 
set $0, 2
lw $6, $0, $3 
set $0, 3
lw $7, $0, $3
set $0, 1
add $1, $1, $0

set $0, 0
bne $4, $0, tag1:
add $5, $2, $5
set $0, 0
lw $5, $0, $5 
add $6, $2, $6
set $0, 0
lw $6, $0, $6 

sub $0, $5, $6
add $7, $2, $7
set $0, 0
sw $0, $0, $7
j tagA:

tag1: set $0, 1
bne $4, $0, tag2:
add $5, $2, $5
set $0, 0
lw $5, $0, $5 
set $0, 1
sr $5, $5, $0 

add $7, $2, $7
set $0, 0
sw $5, $0, $7 //store
j tagA:


tag2: set $0, 2
bne $4, $0, tag3:
add $5, $2, $5
set $0, 0
lw $5, $0, $5
add $6, $2, $6
set $0, 0
lw $6, $0, $6
nor $0, $5, $6
add $7, $2, $7
set $0, 0
sw $0, $0, $7 //store
j tagA:


tag3: set $0, 3
bne $4, $0, tag4:
add $5, $2, $5
set $0, 0
lw $5, $0, $5

add $0, $2, $5
set $0, 0
lw $5, $0, $0

add $6, $2, $6
set $0, 0
lw $6, $0, $6
add $7, $2, $7

set $0, 0
sw $7, $0, $5 // $7 = MM$5
sw $5, $0, $6 // MM$5 = M$6
j tagA:


tag4: set $0, 4
bne $4, $0, tag5:
add $5, $2, $5
set $0, 0
lw $5, $0, $5
add $0, $2, $7
set $0, 0
lw $7, $0, $0
TRAP IN, $7
j tagA:


tag5: set $0, 5
bne $4, $0, tag6:
add $0, $2, $5
set $0, 0
lw $5, $0, $0

set $0, 1
mul $6, $6, $0 
add $0, $2, $6
set $0, 0
lw $6, $0, $0
TRAP, OUT $6
j tagA:


tag6: set $0, 6
bne $4, $0, tag7:
add $0, $2, $5
set $0, 0
lw $5, $0, $0
add $0, $2, $6
set $0, 0
lw $6, $0, $0

add $0, $2, $7
set $0, 0
lw $7, $0, $0
set $0, 0
sw $7, $0, $1
set $0, 0
slt $5, $5, $0
beq $5, $0, tagA:

set $1, 6
j tagA:


tag7: TRAP, QUIT, $1
