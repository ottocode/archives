#define
pc = $1
mem = $2
inst = $3
op = $4
srcA = $5
srcB = $6
dest = $7
temp = $0
INT_SIZE = 1
#end


tagA: add inst, mem, pc
        lw op, inst // Get op
        lw srcA, 1(inst) // Get srcA
        lw srcB, 2(inst) // Get srcB
        lw dest, 3(inst) // Get dest
        set temp, 1
        add pc, pc, temp
       
#*******case 0**********************
        set temp, 0
        bne op, temp, tag1
        add srcA, mem, srcA
        lw srcA, srcA //srcA = M[srcA]
        add srcB, mem, srcB
        lw srcB, srcB //srcB = M[srcB]

        sub temp, srcA, srcB
        add dest, mem, dest
        sw temp, dest
        j tagA
 
        
#*******case 1**********************
tag1: set temp, 1
        bne op, temp, tag2
        add srcA, mem, srcA
        lw srcA, srcA //srcA = M[srcA]
        srl srcA, srcA, 1

        add dest, mem, dest
        sw srcA, dest //store
        j tagA

#*******case 2**********************
tag2: set temp, 2
        bne op, temp, tag3
        add srcA, mem, srcA
        lw srcA, srcA //srcA = M[srcA]
        add srcB, mem, srcB
        lw srcB, srcB //srcB = M[srcB]
        nor temp, srcA, srcB
        
        add dest, mem, dest
        sw temp, dest //store
        j tagA

#*******case 3**********************
tag3: set temp, 3
        bne op, temp, tag4
        add srcA, mem, srcA
        lw srcA, srcA //srcA = M[srcA]

        add temp, mem, srcA
        lw srcA, temp //srcA = M[M[srcA]]

        add srcB, mem, srcB
        lw srcB, srcB //srcB = M[srcB]
        add dest, mem, dest

        sw dest, srcA // dest = MMsrcA
        sw srcA, srcB // MMsrcA = MsrcB
        j tagA

#*******case 4**********************
tag4: set temp, 4
        bne op, temp, tag5
        add srcA, mem, srcA
        lw srcA, srcA
        add temp, mem, dest
        lw dest, temp //dest = M[dest]
        IN dest, srcA
        j tagA

#*******case 5**********************
tag5: set temp, 5
        bne op, temp, tag6
        add temp, mem, srcA
        lw srcA, temp

        mul srcB, srcB, INT_SIZE
        add temp, mem, srcB
        lw srcB, temp //srcB = M[srcB]
        OUT srcA, srcB
        j tagA

#*******case 6**********************
tag6: set temp, 6
       bne op, temp, tag7
        add temp, mem, srcA
        lw srcA, temp
        add temp, mem, srcB
        lw srcB, temp

        add temp, mem, dest
        lw dest, temp
        sw dest, pc
        set temp, 0
        slt srcA, srcA, temp
        beq srcA, temp, tagA

        set pc, srcB
        j tagA

#*******case 7**********************
tag7: QUIT pc

